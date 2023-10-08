resource "random_password" "k3s-token" {
  length           = 64
  special          = false
  override_special = "_%@"
}

locals {
  helm_flags      = var.cilium_helm_flags != "" ? "--set ${var.cilium_helm_flags}" : ""
  k3ver           = var.k3s_version == "" ? "INSTALL_K3S_CHANNEL=stable" : "INSTALL_K3S_VERSION=${var.k3s_version}"
  cil_vers        = var.cilium_version == "" ? "" : "--version ${var.cilium_version}"
  masters_count   = var.ha_control_plane == false ? 1 : 3
  start_ip_master = var.masters.master_start_index != "" ? var.masters.master_start_index : (cidrhost(var.masters.subnet, 1) == var.masters.gw ? element(split(".", cidrhost(var.masters.subnet, 1)), 3) + 1 : element(split(".", cidrhost(var.masters.subnet, 1)), 3))
  local_masters = { for i, v in range(local.masters_count) : v => {
    name          = "${var.cluster_name}-control-node-${i}"
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
  vip = var.api_vip == "" ? "${cidrhost(var.masters.subnet, local.start_ip_master)}" : var.api_vip
}

resource "proxmox_vm_qemu" "master" {
  for_each               = { for key, value in local.local_masters : value.name => value }
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
      sans                      = var.k3s_sans == null ? ["${local.vip}"] : distinct(concat(var.k3s_sans, ["${local.vip}"]))
      node_taints               = var.k3s_master_node_taints
      flannel_backend           = var.cilium == true ? "none" : var.k3s_flannel_backend
      disable                   = var.k3s_disable
      cluster_cidr              = var.k3s_cluster_cidr
      service_cidr              = var.k3s_service_cidr
      net_pol_disable           = var.cilium == true ? true : var.k3s_network_policy_disable
      cloud_contr_disable       = var.k3s_cloud_controller_disable
      kube_proxy_disable        = var.cilium == true ? true : var.k3s_kube_proxy_disable
      secrets_encryption_enable = var.k3s_secrets_encryption_enable
      write_kube_perm           = var.k3s_write_kubeconfig_mode
      master_kubelet_args       = var.k3s_master_kubelet_args
      kube_control_manag_args   = var.k3s_kube_control_manag_args
      kube_proxy_args           = var.k3s_kube_proxy_args
      kube_sched_args           = var.k3s_kube_sched_args
      kube_apiserver_args       = var.k3s_kube_apiserver_args
      master_node_taints        = var.k3s_master_node_taints
      master_node_labels        = var.k3s_master_node_labels
      snapshotter               = var.k3s_snapshotter
    })
    connection {
      type        = "ssh"
      host        = self.ssh_host
      user        = self.ssh_user
      private_key = file(var.private_ssh_key)
    }
  }

  provisioner "file" {
    destination = "/tmp/kube-vip.yaml"
    content = templatefile("${path.module}/templates/k3s/kube-vip.yaml", {
      vip = var.api_vip
      dev = var.kube_vip_dev
    })
    connection {
      type        = "ssh"
      host        = self.ssh_host
      user        = self.ssh_user
      private_key = file(var.private_ssh_key)
    }
  }

  provisioner "remote-exec" {
    # Checks if it is running on first master,if true then init's the first master,else does exit without error.
    inline = [
      "if ip a | grep inet | awk '{print $2}' | grep -w ${cidrhost(var.masters.subnet, local.start_ip_master)};then : ;else exit 0;fi",
      "sudo mkdir -p /etc/rancher/k3s",
      "sudo mv /tmp/config.yaml /etc/rancher/k3s/config.yaml",
      "curl -sfL https://get.k3s.io | sudo ${local.k3ver} sh -s - server --cluster-init --token ${random_password.k3s-token.result}",
      "mkdir /home/$${USER}/.kube/ && sudo cp /etc/rancher/k3s/k3s.yaml /home/$${USER}/.kube/config && sudo chown $${USER} /home/$${USER}/.kube/config",
      "if ${var.kube_vip_enable} == true;then sudo mkdir -p /var/lib/rancher/k3s/server/manifests/ && sudo cp /tmp/kube-vip.yaml /var/lib/rancher/k3s/server/manifests/kube-vip.yaml;else rm /tmp/kube-vip.yaml ;fi",
      "if ${var.cilium} == true;then : ;else exit 0;fi",
      "curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | sudo bash && helm repo add cilium https://helm.cilium.io/",
      "helm install cilium cilium/cilium --namespace kube-system ${local.cil_vers} --set k8sServiceHost=${local.vip},ipam.operator.clusterPoolIPv4PodCIDRList=[\"${var.k3s_cluster_cidr}\"] ${local.helm_flags}",
      "sleep 10 && sudo kubectl get pods --all-namespaces -o custom-columns=NAMESPACE:.metadata.namespace,NAME:.metadata.name,HOSTNETWORK:.spec.hostNetwork --no-headers=true | grep '<none>' | awk '{print \"-n \"$1\" \"$2}' | xargs -L 1 -r sudo kubectl delete pod",
      "sudo rm -rf /home/$${USER}/.kube"
    ]
    connection {
      type        = "ssh"
      host        = self.ssh_host
      user        = self.ssh_user
      private_key = file(var.private_ssh_key)
    }
  }
  provisioner "remote-exec" {
    # Checks if it is running in a non-first master,if true joins itself to the first master, else exits without error
    inline = [
      "if ip a | grep inet | awk '{print $2}' | grep -w ${cidrhost(var.masters.subnet, local.start_ip_master)};then exit 0;fi",
      "sleep $((RANDOM % 30))",
      "sudo mkdir -p /etc/rancher/k3s",
      "sudo mv /tmp/config.yaml /etc/rancher/k3s/config.yaml",
      "if ${var.kube_vip_enable} == true;then sudo mkdir -p /var/lib/rancher/k3s/server/manifests && sudo cp /tmp/kube-vip.yaml /var/lib/rancher/k3s/server/manifests/kube-vip.yaml;else rm /tmp/kube-vip.yaml ;fi",
      "curl -sfL https://get.k3s.io | sudo ${local.k3ver} sh -s - server --server https://${local.vip}:6443 --token ${random_password.k3s-token.result}",
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
      qemu_os,
      ciuser
    ]
  }

  depends_on = [
    resource.random_password.k3s-token
  ]
}
