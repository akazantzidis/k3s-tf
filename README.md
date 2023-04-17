<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=0.13 |
| <a name="requirement_proxmox"></a> [proxmox](#requirement\_proxmox) | >=2.9.11 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_proxmox"></a> [proxmox](#provider\_proxmox) | 2.9.13 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.4.3 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [proxmox_vm_qemu.master](https://registry.terraform.io/providers/telmate/proxmox/latest/docs/resources/vm_qemu) | resource |
| [proxmox_vm_qemu.worker](https://registry.terraform.io/providers/telmate/proxmox/latest/docs/resources/vm_qemu) | resource |
| [random_password.k3s-token](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_shuffle.random_node](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/shuffle) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloudinit_cipassword"></a> [cloudinit\_cipassword](#input\_cloudinit\_cipassword) | n/a | `string` | `""` | no |
| <a name="input_cloudinit_nameserver"></a> [cloudinit\_nameserver](#input\_cloudinit\_nameserver) | n/a | `string` | `null` | no |
| <a name="input_cloudinit_search_domain"></a> [cloudinit\_search\_domain](#input\_cloudinit\_search\_domain) | n/a | `string` | `null` | no |
| <a name="input_cloudinit_sshkeys"></a> [cloudinit\_sshkeys](#input\_cloudinit\_sshkeys) | n/a | `string` | `""` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | n/a | `string` | `"default-cluster"` | no |
| <a name="input_gw"></a> [gw](#input\_gw) | n/a | `string` | `"192.168.1.1"` | no |
| <a name="input_ha_control_plane"></a> [ha\_control\_plane](#input\_ha\_control\_plane) | n/a | `bool` | `false` | no |
| <a name="input_masters"></a> [masters](#input\_masters) | n/a | <pre>object({<br>    name      = optional(string, "control")<br>    node      = optional(string, "")<br>    pool      = optional(string, null)<br>    cores     = optional(number, 1)<br>    memory    = optional(number, 2048)<br>    bridge    = optional(string, "vmbr0")<br>    tag       = optional(number, -1)<br>    tags      = optional(list(string), ["terraform-managed-master"])<br>    ipconfig0 = optional(string, "")<br>    scsihw    = optional(string, "virtio-scsi-pci")<br>    disks = optional(list(object({<br>      id      = optional(number, 0)<br>      size    = optional(string, "10G")<br>      storage = optional(string, "local-lvm")<br>      type    = optional(string, "virtio")<br>      discard = optional(string, null)<br>      ssd = optional(number, 0) })), [<br>      {<br>        id   = 0<br>        size = "10G"<br>    }])<br>    image              = string<br>    ssh_user           = string<br>    user_password      = string<br>    ssh_keys           = string<br>    subnet             = string<br>    gw                 = string<br>    master_start_index = optional(string, "")<br>  })</pre> | n/a | yes |
| <a name="input_pools"></a> [pools](#input\_pools) | n/a | <pre>list(object({<br>    name      = optional(string, "node")<br>    workers   = optional(number, 1)<br>    node      = optional(string, "")<br>    pool      = optional(string, null)<br>    cores     = optional(number, 1)<br>    memory    = optional(number, 2048)<br>    bridge    = optional(string, "vmbr0")<br>    tag       = optional(number, -1)<br>    tags      = optional(list(string), ["terraform-managed-worker"])<br>    ipconfig0 = optional(string, "")<br>    scsihw    = optional(string, "virtio-scsi-pci")<br>    disks = optional(list(object({<br>      id      = optional(number, 0)<br>      size    = optional(string, "10G")<br>      storage = optional(string, "local-lvm")<br>      type    = optional(string, "virtio")<br>      discard = optional(string, null)<br>      ssd = optional(number, 0) })),<br>      [{<br>        id   = 0<br>        size = "10G"<br>    }])<br>    image              = string<br>    ssh_user           = string<br>    user_password      = string<br>    ssh_keys           = string<br>    subnet             = string<br>    gw                 = string<br>    worker_start_index = optional(string, "")<br>  }))</pre> | n/a | yes |
| <a name="input_proxmox_nodes"></a> [proxmox\_nodes](#input\_proxmox\_nodes) | n/a | `list(string)` | n/a | yes |
| <a name="input_sec_pm_api_url"></a> [sec\_pm\_api\_url](#input\_sec\_pm\_api\_url) | n/a | `string` | `""` | no |
| <a name="input_sec_pm_otp"></a> [sec\_pm\_otp](#input\_sec\_pm\_otp) | n/a | `string` | `null` | no |
| <a name="input_sec_pm_password"></a> [sec\_pm\_password](#input\_sec\_pm\_password) | n/a | `string` | `""` | no |
| <a name="input_sec_pm_tls_insecure"></a> [sec\_pm\_tls\_insecure](#input\_sec\_pm\_tls\_insecure) | n/a | `bool` | `true` | no |
| <a name="input_sec_pm_user"></a> [sec\_pm\_user](#input\_sec\_pm\_user) | n/a | `string` | `""` | no |
| <a name="input_subnet"></a> [subnet](#input\_subnet) | n/a | `string` | `"192.168.1.1/24"` | no |
| <a name="input_vm_boot"></a> [vm\_boot](#input\_vm\_boot) | n/a | `string` | `"order=virtio0"` | no |
| <a name="input_vm_cpu_type"></a> [vm\_cpu\_type](#input\_vm\_cpu\_type) | n/a | `string` | `"host"` | no |
| <a name="input_vm_pool"></a> [vm\_pool](#input\_vm\_pool) | n/a | `string` | `null` | no |
| <a name="input_vm_sockets"></a> [vm\_sockets](#input\_vm\_sockets) | n/a | `number` | `1` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_masters"></a> [masters](#output\_masters) | n/a |
| <a name="output_workers"></a> [workers](#output\_workers) | n/a |
<!-- END_TF_DOCS -->
