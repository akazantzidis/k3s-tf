provider "proxmox" {
  pm_tls_insecure = null
  pm_api_url      = "https://proxmox/api2/json"
  pm_password     = "password"
  pm_user         = "root@pam"
  pm_otp          = null
}

module "k3s" {
  source           = "github.com/akazantzidis/k3s-tf"
  ha_control_plane = false
  k3s_version      = ""
  masters = {
    tag = 100
    disks = [{
      size    = "10G"
      storage = "NVME"
    }]
    image              = "ubuntu2204"
    ssh_user           = "ubuntu"
    user_password      = "ubuntu"
    ssh_keys           = "ssh-key-here"
    subnet             = "192.168.100.0/24"
    gw                 = "192.168.100.1"
    tags               = ["dev", "teamA"]
    master_start_index = ""
  }
  pools = [{
    name    = "pool0"
    workers = 1
    tag     = 100
    disks = [{
      size    = "10G"
      storage = "NVME"
    }]
    image              = "ubuntu2204"
    ssh_user           = "ubuntu"
    user_password      = "ubuntu"
    ssh_keys           = ""
    subnet             = "192.168.100.0/24"
    gw                 = "192.168.100.1"
    tags               = ["dev", "teamA"]
    worker_start_index = ""
    },
    {
      name    = "pool1"
      workers = 1
      tag     = 110
      disks = [{
        size    = "10G"
        storage = "NVME"
      }]
      image              = "debianSID"
      ssh_user           = "debian"
      user_password      = "debian"
      ssh_keys           = ""
      subnet             = "192.168.110.0/24"
      gw                 = "192.168.110.1"
      worker_start_index = ""
    }
  ]
  proxmox_nodes       = ["node1"]
  k3s_sans            = ["api.192.168.100.19.nip.io", "192.168.100.19", "api.192.168.100.20.nip.io", "192.168.100.20"]
  api_vip             = "192.168.100.19"
  cilium              = false
  k3s_flannel_backend = "wireguard-native"
  kube_vip_enable     = false
}

output "masters" {
  value = module.k3s.masters
}

output "workers" {
  value = module.k3s.workers
}

terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "2.9.14"
    }
  }
}
