
resource "random_password" "k3s-token" {
  length           = 64
  special          = false
  override_special = "_%@"
}

locals {
  k3ver           = var.k3s_version == "" ? "INSTALL_K3S_CHANNEL=stable" : "INSTALL_K3S_VERSION=${var.k3s_version}"
  masters_count   = var.ha_control_plane == false ? 1 : 3
  start_ip_master = var.masters.master_start_index != "" ? var.masters.master_start_index : (cidrhost(var.masters.subnet, 1) == var.masters.gw ? element(split(".", cidrhost(var.masters.subnet, 1)), 3) + 1 : element(split(".", cidrhost(var.masters.subnet, 1)), 3))
  local_masters = { for i, v in range(local.masters_count) : v => {
    name          = "${var.cluster_name}-${var.masters.name}-node-${i}"
    node          = var.masters.node != "" ? var.masters.node : random_shuffle.random_node.result[0]
    pool          = var.masters.pool
    cores         = var.masters.cores
    memory        = var.masters.memory
    bridge        = var.masters.bridge
    tag           = var.masters.tag
    tags          = join(" ", concat([for i in var.masters.tags : i], ["cluster-${var.cluster_name}"], ["control-node"]))
    ipconfig0     = var.masters.ipconfig0 != "dhcp" ? "ip=${cidrhost(var.masters.subnet, local.start_ip_master + i)}/${element(split("/", var.masters.subnet), 1)},gw=${var.masters.gw}" : "dhcp"
    scsihw        = var.masters.scsihw
    disks         = var.masters.disks
    image         = var.masters.image
    ssh_user      = var.masters.ssh_user
    user_password = var.masters.user_password
    ssh_keys      = var.masters.ssh_keys
    }
  }
}

resource "proxmox_vm_qemu" "master" {
  for_each               = local.local_masters
  name                   = each.value.name
  desc                   = "k3s Master node - Terraform managed"
  define_connection_info = "true"
  clone                  = each.value.image
  agent                  = "1"
  os_type                = "cloud-init"
  boot                   = var.vm_boot
  tags                   = each.value.tags
  oncreate               = "true"
  onboot                 = "true"
  sshkeys                = each.value.ssh_keys
  cipassword             = each.value.user_password
  searchdomain           = var.cloudinit_search_domain
  nameserver             = var.cloudinit_nameserver
  ipconfig0              = each.value.ipconfig0
  ssh_user               = each.value.ssh_user
  target_node            = each.value.node
  pool                   = each.value.pool
  cores                  = each.value.cores
  sockets                = var.vm_sockets
  cpu                    = var.vm_cpu_type
  memory                 = each.value.memory
  scsihw                 = each.value.scsihw

  vga {
    type   = "qxl"
    memory = 0
  }

  dynamic "disk" {
    for_each = each.value.disks
    content {
      slot    = disk.value.id
      size    = disk.value.size
      storage = disk.value.storage
      type    = disk.value.type
      ssd     = disk.value.ssd
      discard = disk.value.discard
    }
  }

  network {
    model  = "virtio"
    bridge = each.value.bridge
    tag    = each.value.tag
    queues = each.value.cores
  }

  serial {
    id   = 0
    type = "socket"
  }

  connection {
    type = "ssh"
    host = self.ssh_host
    user = self.ssh_user
  }
  provisioner "file" {
    destination = "/tmp/config.yaml"
    content = templatefile("${path.module}/templates/k3s/server.yaml", {
      node-ip                   = self.ssh_host
      sans                      = var.k3s_sans
      node_taints               = var.k3s_master_node_taints
      flannel_backend           = var.k3s_flannel_backend
      disable                   = var.k3s_disable
      cluster_cidr              = var.k3s_cluster_cidr
      service_cidr              = var.k3s_service_cidr
      net_pol_disable           = var.k3s_network_policy_disable
      cloud_contr_disable       = var.k3s_cloud_controller_disable
      kube_proxy_disable        = var.k3s_kube_proxy_disable
      secrets_encryption_enable = var.k3s_secrets_encryption_enable
      write_kube_perm           = var.k3s_write_kubeconfig_mode
      master_kubelet_args       = var.k3s_master_kubelet_args
      kube_control_manag_args   = var.k3s_kube_control_manag_args
      kube_proxy_args           = var.k3s_kube_proxy_args
      kube_sched_args           = var.k3s_kube_sched_args
      kube_apiserver_args       = var.k3s_kube_apiserver_args
      master_node_taints        = var.k3s_master_node_taints
      master_node_labels        = var.k3s_master_node_labels
    })
    connection {
      type        = "ssh"
      host        = self.ssh_host
      user        = self.ssh_user
      private_key = file("~/.ssh/id_ed25519")
    }
  }
  provisioner "remote-exec" {
    # Check if is running on first master,IF YES then init's the first master,else does exit without error.
    inline = [
      "if ip a | grep inet | awk '{print $2}' | grep -w ${cidrhost(var.masters.subnet, local.start_ip_master)};then : ;else exit 0;fi",
      "sudo mkdir -p /etc/rancher/k3s",
      "sudo mv /tmp/config.yaml /etc/rancher/k3s/config.yaml",
      "curl -sfL https://get.k3s.io | sudo ${local.k3ver} sh -s - server --cluster-init --token ${random_password.k3s-token.result}"
    ]
    connection {
      type        = "ssh"
      host        = self.ssh_host
      user        = self.ssh_user
      private_key = file(var.private_ssh_key)
    }
  }
  provisioner "remote-exec" {
    # Checks if is running in the not first master , IF YES it joins the N master to the first master, else exits without error
    inline = [
      "if ip a | grep inet | awk '{print $2}' | grep -w ${cidrhost(var.masters.subnet, local.start_ip_master)};then exit 0;fi",
      "sleep 30",
      "sudo mkdir -p /etc/rancher/k3s",
      "sudo mv /tmp/config.yaml /etc/rancher/k3s/config.yaml",
      "curl -sfL https://get.k3s.io | sudo ${local.k3ver} sh -s - server --server https://${cidrhost(var.masters.subnet, local.start_ip_master)}:6443 --token ${random_password.k3s-token.result}",
      "sleep 5"
    ]
    connection {
      type        = "ssh"
      host        = self.ssh_host
      user        = self.ssh_user
      private_key = file(var.private_ssh_key)
    }
  }
  lifecycle {
    ignore_changes = [
      disk,
      network,
      serial,
      vga,
      tags,
      qemu_os
    ]
  }

  depends_on = [
    resource.random_password.k3s-token
  ]
}
