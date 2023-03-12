provider "proxmox" {
  pm_tls_insecure = null
  pm_api_url      = "https://proxmox/api2/json"
  pm_password     = "123456"
  pm_user         = "root@pam"
  pm_otp          = null
}

module "cluster-k3s" {
  source           = "github.com/akazantzidis/k3s-tf"
  ha_control_plane = false
  masters = {
    tag = 100
    disks = [{
      size    = "10G"
      storage = "NVME"
    }]
    image         = "debianSID"
    ssh_user      = "debian"
    user_password = "debian"
    ssh_keys      = ""
    subnet        = "192.168.100.0/24"
    subnet_mask   = "24"
    gw            = "192.168.100.1"
    tags          = ["dev", "teamA"]
  }
  pools = [{
    name    = "default"
    workers = 1
    tag     = 100
    disks = [{
      size    = "10G"
      storage = "NVME"
    }]
    image         = "debianSID"
    ssh_user      = "debian"
    user_password = "debian"
    ssh_keys      = ""
    subnet        = "192.168.100.0/24"
    subnet_mask   = "24"
    gw            = "192.168.100.1"
    tags          = ["dev", "teamA"]
    },
    #    {
    #      name    = "pool1"
    #      workers = 1
    #      tag     = 110
    #      disks = [{
    #        size    = "10G"
    #        storage = "NVME"
    #      }]
    #      image         = "debianSID"
    #      ssh_user      = "debian"
    #      user_password = "debian"
    #      ssh_keys      = ""
    #      subnet        = "192.168.110.0/24"
    #      subnet_mask   = "24"
    #      gw            = "192.168.110.1"
    #  }
  ]
  proxmox_nodes = ["proxmox1"]
  exec_ansible  = false
}

output "masters" {
  value = module.cluster-k3s.masters
}

output "workers" {
  value = module.cluster-k3s.workers
}

terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "2.9.13"
    }
  }
}
