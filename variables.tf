variable "ha_control_plane" {
  type    = bool
  default = false
}

variable "cluster_name" {
  type    = string
  default = "default-cluster"
}

variable "masters" {
  type = object({
    name      = optional(string, "control")
    node      = optional(string, "")
    pool      = optional(string, null)
    cores     = optional(number, 1)
    memory    = optional(number, 2048)
    bridge    = optional(string, "vmbr0")
    tag       = optional(number, -1)
    tags      = optional(list(string), ["terraform-managed-master"])
    ipconfig0 = optional(string, "")
    scsihw    = optional(string, "virtio-scsi-pci")
    disks = optional(list(object({
      id      = optional(number, 0)
      size    = optional(string, "10G")
      storage = optional(string, "local-lvm")
      type    = optional(string, "virtio")
      discard = optional(string, null)
      ssd = optional(number, 0) })), [
      {
        id   = 0
        size = "10G"
    }])
    image         = string
    ssh_user      = string
    user_password = string
    ssh_keys      = string
    subnet        = string
    subnet_mask   = string
    gw            = string
  })
}

variable "proxmox_nodes" {
  type = list(string)
}

variable "pools" {
  type = list(object({
    name      = optional(string, "node")
    workers   = optional(number, 1)
    node      = optional(string, "")
    pool      = optional(string, null)
    cores     = optional(number, 1)
    memory    = optional(number, 2048)
    bridge    = optional(string, "vmbr0")
    tag       = optional(number, -1)
    tags      = optional(list(string), ["terraform-managed-worker"])
    ipconfig0 = optional(string, "")
    scsihw    = optional(string, "virtio-scsi-pci")
    disks = optional(list(object({
      id      = optional(number, 0)
      size    = optional(string, "10G")
      storage = optional(string, "local-lvm")
      type    = optional(string, "virtio")
      discard = optional(string, null)
      ssd = optional(number, 0) })),
      [{
        id   = 0
        size = "10G"
    }])
    image         = string
    ssh_user      = string
    user_password = string
    ssh_keys      = string
    subnet        = string
    subnet_mask   = string
    gw            = string
  }))
}

variable "sec_pm_tls_insecure" {
  type    = bool
  default = true
}
variable "sec_pm_api_url" {
  type      = string
  sensitive = true
  default   = ""
}
variable "sec_pm_password" {
  type      = string
  sensitive = true
  default   = ""
}
variable "sec_pm_user" {
  type      = string
  sensitive = true
  default   = ""
}
variable "sec_pm_otp" {
  type      = string
  default   = null
  sensitive = true
}

variable "cloudinit_sshkeys" {
  type      = string
  sensitive = true
  default   = ""
}
variable "cloudinit_cipassword" {
  type      = string
  sensitive = true
  default   = ""
}

variable "vm_pool" {
  type    = string
  default = null
}

variable "cloudinit_search_domain" {
  type    = string
  default = null
}

variable "cloudinit_nameserver" {
  type    = string
  default = null
}

variable "vm_cpu_type" {
  type    = string
  default = "host"
}

variable "vm_sockets" {
  type    = number
  default = 1
}

variable "vm_boot" {
  type    = string
  default = "order=virtio0"
}

variable "subnet" {
  type    = string
  default = "192.168.1.1/24"

  validation {
    condition     = can(cidrsubnet(var.subnet, 0, 0))
    error_message = "Not valid subnet CIDR"
  }
}

variable "gw" {
  type    = string
  default = "192.168.1.1"

  validation {
    condition     = can(regex("^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$", var.gw))
    error_message = "Not valid gateway ip address"
  }
}

variable "subnet_mask" {
  type    = string
  default = "24"

  validation {
    condition = (var.subnet_mask >= 1 &&
    var.subnet_mask <= 32)
    error_message = "Not valid subnet mask"
  }
}

variable "exec_ansible" {
  type    = bool
  default = true
}
