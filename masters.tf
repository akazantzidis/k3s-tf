locals {
  masters_count = var.ha_control_plane == false ? 1 : 3
  local_masters = { for i, v in range(local.masters_count) : v => {
    name          = "${var.cluster_name}-${var.masters.name}-node-${i}"
    node          = var.masters.node != "" ? var.masters.node : random_shuffle.random_node.result[0]
    pool          = var.masters.pool
    cores         = var.masters.cores
    memory        = var.masters.memory
    bridge        = var.masters.bridge
    tag           = var.masters.tag
    tags          = var.masters.tags
    ipconfig0     = var.masters.ipconfig0 != "dhcp" ? "ip=${cidrhost(var.masters.subnet, 2 + i)}/${var.masters.subnet_mask},gw=${var.masters.gw}" : "dhcp"
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
  tags                   = tostring(each.value.tags)
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
    port = self.ssh_port
  }

  lifecycle {
    ignore_changes = [
      disk,
      network,
      serial,
      vga
    ]
  }
}
