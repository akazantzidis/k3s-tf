locals {
  get_last_master_ip = element(split("/", element(split(",", element(
  split(".", element([for vm in proxmox_vm_qemu.master : vm.ipconfig0], length([for vm in proxmox_vm_qemu.master : vm.ipconfig0]) - 1)), 3)), 0)), 0)
  local_workers = flatten([for pool in var.pools : [
    for worker in range(pool.workers) : {
      name   = "${var.cluster_name}-${pool.name}-worker-node-${worker}"
      node   = pool.node != "" ? pool.node : "random"
      pool   = pool.pool
      cores  = pool.cores
      memory = pool.memory
      bridge = pool.bridge
      tag    = pool.tag
      tags   = join(" ", concat([for i in pool.tags : i], ["cluster-${var.cluster_name}"], ["${pool.name}-pool"], ["worker-node"]))
      subnet = pool.subnet
      gw     = pool.gw
      # The below is ugly but seem to work :o !!
      ipconfig0 = "ip=${cidrhost(pool.subnet, (pool.worker_start_index != "" ? pool.worker_start_index + worker :
        ((pool.subnet == var.masters.subnet) ? (local.get_last_master_ip + 1) + worker :
          ((element(split(".", pool.gw), 3) <= 253) ? (element(split(".", pool.gw), 3) + 1) + worker :
        1 + worker))))
      }/${element(split("/", pool.subnet), 1)},gw=${pool.gw}"
      scsihw        = pool.scsihw
      disks         = pool.disks
      image         = pool.image
      ssh_user      = pool.ssh_user
      user_password = pool.user_password
      ssh_keys      = pool.ssh_keys
    }
    ]
    ]
  )
}

resource "proxmox_vm_qemu" "worker" {
  for_each               = { for key, value in local.local_workers : value.name => value }
  name                   = each.value.name
  desc                   = "k3s worker node - Terraform managed"
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
  target_node            = each.value.node != "random" ? each.value.node : element(random_shuffle.random_node.result, substr(each.key, -1, -1))
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

  provisioner "file" {
    destination = "/tmp/config.yaml"
    content = templatefile("${path.module}/templates/k3s/agent.yaml", {
      node-ip                 = self.ssh_host
      worker_kubelet_args     = var.k3s_worker_kubelet_args
      worker_node_labels      = var.k3s_worker_node_labels
      worker_node_taints      = var.k3s_worker_node_taints
      protect_kernel_defaults = var.k3s_worker_protect_kernel_defaults
      snapshotter             = var.k3s_snapshotter
    })
    connection {
      type        = "ssh"
      host        = self.ssh_host
      user        = self.ssh_user
      private_key = var.private_ssh_key
    }
  }
  provisioner "remote-exec" {
    inline = [
      "sudo mkdir -p /etc/rancher/k3s",
      "sudo mv /tmp/config.yaml /etc/rancher/k3s/config.yaml",
      "curl -sfL https://get.k3s.io | ${local.k3ver} sudo -s sh -s - agent --server https://${local.vip}:6443 --token ${random_password.k3s-token.result}"
    ]
    connection {
      type        = "ssh"
      host        = self.ssh_host
      user        = self.ssh_user
      private_key = var.private_ssh_key
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
    random_shuffle.random_node,
  ]
}
