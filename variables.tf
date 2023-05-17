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
    image              = string
    ssh_user           = string
    user_password      = string
    ssh_keys           = string
    subnet             = string
    gw                 = string
    master_start_index = optional(string, "")
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
    image              = string
    ssh_user           = string
    user_password      = string
    ssh_keys           = string
    subnet             = string
    gw                 = string
    worker_start_index = optional(string, "")
  }))
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

variable "k3s_master_kubelet_args" {
  type    = list(string)
  default = ["feature-gates=MixedProtocolLBService=true"]
}

variable "k3s_worker_kubelet_args" {
  type    = list(string)
  default = ["feature-gates=MixedProtocolLBService=true"]
}

variable "k3s_kube_control_manag_args" {
  type    = list(string)
  default = ["feature-gates=MixedProtocolLBService=true", "bind-address=0.0.0.0"]
}

variable "k3s_kube_proxy_args" {
  type    = list(string)
  default = ["feature-gates=MixedProtocolLBService=true", "bind-address=0.0.0.0"]
}

variable "k3s_kube_sched_args" {
  type    = list(string)
  default = ["feature-gates=MixedProtocolLBService=true", "bind-address=0.0.0.0"]
}

variable "k3s_kube_apiserver_args" {
  type    = list(string)
  default = ["feature-gates=MixedProtocolLBService=true"]
}

variable "k3s_master_node_taints" {
  type    = list(string)
  default = ["k3s-controlplane=true:NoExecute", "CriticalAddonsOnly=true:NoExecute"]
}

variable "k3s_worker_node_taints" {
  type    = list(string)
  default = []
}

variable "k3s_master_node_labels" {
  type    = list(string)
  default = []
}

variable "k3s_worker_node_labels" {
  type    = list(string)
  default = ["node.kubernetes.io/worker=true"]
}

variable "k3s_network_policy_disable" {
  type    = bool
  default = false
}

variable "k3s_cloud_controller_disable" {
  type    = bool
  default = true
}

variable "k3s_kube_proxy_disable" {
  type    = bool
  default = false
}

variable "k3s_secrets_encryption_enable" {
  type    = bool
  default = true
}

variable "k3s_write_kubeconfig_mode" {
  type    = string
  default = "600"
}

variable "k3s_cluster_cidr" {
  type    = string
  default = "10.86.0.0/16"
}

variable "k3s_service_cidr" {
  type    = string
  default = "10.88.0.0/16"
}

variable "k3s_sans" {
  type    = list(string)
  default = ["k8s.local"]
}

variable "k3s_flannel_backend" {
  type    = string
  default = "vxlan"
}

variable "k3s_disable" {
  type    = list(string)
  default = ["traefik", "servicelb", "metrics-server", "local-storage"]
}

variable "k3s_worker_protect_kernel_defaults" {
  type    = bool
  default = false
}


variable "k3s_worker_snapshotter" {
  type    = string
  default = "native"
}
