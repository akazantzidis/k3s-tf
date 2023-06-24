variable "ha_control_plane" {
  description = "Set HA for K3S control plane.If HA true then 3 master nodes are provisioned."
  type        = bool
  default     = false
}

variable "cluster_name" {
  description = "Cluster name."
  type        = string
  default     = "test-cluster"
}

variable "masters" {
  description = "Master nodes configuration options"
  type = object({
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
  description = "List of proxmox nodes availiable for k3s nodes setup."
  type        = list(string)
}

variable "pools" {
  description = "Worker pools configuration options"
  type = list(object({
    name      = string
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
  description = "VM's DNS domain search"
  type        = string
  default     = null
}

variable "cloudinit_nameserver" {
  description = "VM's DNS server"
  type        = string
  default     = null
}

variable "vm_cpu_type" {
  description = "VM's CPU type"
  type        = string
  default     = "host"
}

variable "vm_sockets" {
  description = "VM's CPU sockets"
  type        = number
  default     = 1
}

variable "vm_boot" {
  description = "VM's boot device configuration"
  type        = string
  default     = "order=virtio0"
}

variable "subnet" {
  description = ""
  type        = string
  default     = "192.168.1.1/24"

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
  description = "k3s masters kubelet arguments"
  type        = list(string)
  default     = ["feature-gates=MixedProtocolLBService=true"]
}

variable "k3s_worker_kubelet_args" {
  description = "k3s workers kubelet arguments"
  type        = list(string)
  default     = ["feature-gates=MixedProtocolLBService=true"]
}

variable "k3s_kube_control_manag_args" {
  description = "k3s controller-manager extra configuration"
  type        = list(string)
  default     = ["feature-gates=MixedProtocolLBService=true", "bind-address=0.0.0.0"]
}

variable "k3s_kube_proxy_args" {
  description = "k3s kube-proxy extra configuration"
  type        = list(string)
  default     = ["feature-gates=MixedProtocolLBService=true", "bind-address=0.0.0.0"]
}

variable "k3s_kube_sched_args" {
  description = "k3s scheduler extra configuration"
  type        = list(string)
  default     = ["feature-gates=MixedProtocolLBService=true", "bind-address=0.0.0.0"]
}

variable "k3s_kube_apiserver_args" {
  description = "k3s api server extra configuration"
  type        = list(string)
  default     = ["feature-gates=MixedProtocolLBService=true"]
}

variable "k3s_master_node_taints" {
  description = "k3s master taints"
  type        = list(string)
  default     = ["k3s-controlplane=true:NoExecute", "CriticalAddonsOnly=true:NoExecute"]
}

variable "k3s_worker_node_taints" {
  description = "k3s worker taints"
  type        = list(string)
  default     = []
}

variable "k3s_master_node_labels" {
  description = "K3s master labels"
  type        = list(string)
  default     = []
}

variable "k3s_worker_node_labels" {
  description = "k3s worker labels"
  type        = list(string)
  default     = []
}

variable "k3s_network_policy_disable" {
  description = "k3s default network policy controller configuration"
  type        = bool
  default     = false
}

variable "k3s_cloud_controller_disable" {
  description = "k3s default network cloud controller configuration"
  type        = bool
  default     = true
}

variable "k3s_kube_proxy_disable" {
  description = "k3s default kube-proxy configuration"
  type        = bool
  default     = false
}

variable "k3s_secrets_encryption_enable" {
  description = "K3s default secrets encryption configuration"
  type        = bool
  default     = true
}

variable "k3s_write_kubeconfig_mode" {
  description = "K3s default kube-config configuration"
  type        = string
  default     = "640"
}

variable "k3s_cluster_cidr" {
  description = "k3s cluster pod cidr configuration"
  type        = string
  default     = "10.86.0.0/16"
}

variable "k3s_service_cidr" {
  description = "K3s cluster service cidr configuration"
  type        = string
  default     = "10.88.0.0/16"
}

variable "k3s_sans" {
  description = "K3s default certificate included entries configuration"
  type        = list(string)
  default     = null
}

variable "k3s_flannel_backend" {
  description = "k3s default network backend configuration"
  type        = string
  default     = "vxlan"
}

variable "k3s_disable" {
  description = "k3s addons disable configuration"
  type        = list(string)
  default     = ["traefik", "servicelb", "local-storage"] #"metrics-server",
}

variable "k3s_worker_protect_kernel_defaults" {
  description = "k3s protect kernel defaults configuration"
  type        = bool
  default     = false
}


variable "k3s_snapshotter" {
  description = "k3s default snapshotter configuration"
  type        = string
  default     = "native"
}

variable "private_ssh_key" {
  type        = string
  description = "The path is stored the private ssh key which matches the ssh authorized keys which were set"
  default     = "~/.ssh/id_ed25519"
}

variable "k3s_version" {
  type        = string
  description = "The k3s version to be installed.Eg. vX.Y.Z-rc1"
  default     = ""
}

variable "cilium" {
  type        = bool
  description = "Install Cillium cni"
  default     = false
}

variable "cilium_version" {
  type        = string
  description = "Cillium version to install.Example 1.13.2"
  default     = ""
}

variable "cilium_helm_flags" {
  type        = string
  description = "Cillium helm arguments delimited with ','.Example key1=value,key2=value"
  default     = "k8sServicePort=6443,ipam.mode=kubernetes,operator.replicas=1"
}

variable "api_vip" {
  type        = string
  description = "VIP ip address for k8s api.Can be an existing infrastructure loadbalancer."
  default     = ""
}

variable "kube_vip_enable" {
  type    = bool
  default = false
}

variable "kube_vip_dev" {
  type    = string
  default = "eth0"
}
