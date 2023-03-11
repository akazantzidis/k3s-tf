<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_proxmox"></a> [proxmox](#requirement\_proxmox) | 2.9.11 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_local"></a> [local](#provider\_local) | 2.4.0 |
| <a name="provider_null"></a> [null](#provider\_null) | 3.2.1 |
| <a name="provider_proxmox"></a> [proxmox](#provider\_proxmox) | 2.9.11 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.4.3 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [local_file.ansible_requirements](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.ansible_roles_folder](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.generate_ansible_cfg](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.generate_install_playbook](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.inventory](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.kubernetes_k3s](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.kubernetes_k3s_masters](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.kubernetes_k3s_workers](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [null_resource.install_ansible_galaxy_requirements](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.install_k3s_cluster](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.sleep_pre_ansible](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.start](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [proxmox_vm_qemu.master](https://registry.terraform.io/providers/telmate/proxmox/2.9.11/docs/resources/vm_qemu) | resource |
| [proxmox_vm_qemu.worker](https://registry.terraform.io/providers/telmate/proxmox/2.9.11/docs/resources/vm_qemu) | resource |
| [random_shuffle.random_node](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/shuffle) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloudinit_cipassword"></a> [cloudinit\_cipassword](#input\_cloudinit\_cipassword) | n/a | `string` | `""` | no |
| <a name="input_cloudinit_nameserver"></a> [cloudinit\_nameserver](#input\_cloudinit\_nameserver) | n/a | `string` | `null` | no |
| <a name="input_cloudinit_search_domain"></a> [cloudinit\_search\_domain](#input\_cloudinit\_search\_domain) | n/a | `string` | `null` | no |
| <a name="input_cloudinit_sshkeys"></a> [cloudinit\_sshkeys](#input\_cloudinit\_sshkeys) | n/a | `string` | `""` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | n/a | `string` | `"default-cluster"` | no |
| <a name="input_exec_ansible"></a> [exec\_ansible](#input\_exec\_ansible) | n/a | `bool` | `true` | no |
| <a name="input_gw"></a> [gw](#input\_gw) | n/a | `string` | `"192.168.1.1"` | no |
| <a name="input_ha_control_plane"></a> [ha\_control\_plane](#input\_ha\_control\_plane) | n/a | `bool` | `false` | no |
| <a name="input_masters"></a> [masters](#input\_masters) | n/a | <pre>object({<br>    name      = optional(string, "control")<br>    node      = optional(string, "")<br>    pool      = optional(string, null)<br>    cores     = optional(number, 1)<br>    memory    = optional(number, 2048)<br>    bridge    = optional(string, "vmbr0")<br>    tag       = optional(number, -1)<br>    tags      = optional(string, "terraform-managed-master")<br>    ipconfig0 = optional(string, "")<br>    disks = optional(list(object({<br>      id      = optional(number, 0)<br>      size    = optional(string, "10G")<br>      storage = optional(string, "local-lvm")<br>      type    = optional(string, "scsi")<br>      discard = optional(string, "ignore")<br>      ssd = optional(number, 0) })), [<br>      {<br>        id   = 0<br>        size = "10G"<br>    }])<br>    image         = string<br>    ssh_user      = string<br>    user_password = string<br>    ssh_keys      = string<br>    subnet        = string<br>    subnet_mask   = string<br>    gw            = string<br>  })</pre> | n/a | yes |
| <a name="input_pools"></a> [pools](#input\_pools) | n/a | <pre>list(object({<br>    name      = optional(string, "node")<br>    workers   = optional(number, 1)<br>    node      = optional(string, "")<br>    pool      = optional(string, null)<br>    cores     = optional(number, 1)<br>    memory    = optional(number, 2048)<br>    bridge    = optional(string, "vmbr0")<br>    tag       = optional(number, -1)<br>    tags      = optional(string, "terraform-managed-worker")<br>    ipconfig0 = optional(string, "")<br>    disks = optional(list(object({<br>      id      = optional(number, 0)<br>      size    = optional(string, "10G")<br>      storage = optional(string, "local-lvm")<br>      type    = optional(string, "scsi")<br>      discard = optional(string, "ignore")<br>      ssd = optional(number, 0) })),<br>      [{<br>        id   = 0<br>        size = "10G"<br>    }])<br>    image         = string<br>    ssh_user      = string<br>    user_password = string<br>    ssh_keys      = string<br>    subnet        = string<br>    subnet_mask   = string<br>    gw            = string<br>  }))</pre> | n/a | yes |
| <a name="input_proxmox_nodes"></a> [proxmox\_nodes](#input\_proxmox\_nodes) | n/a | `list(string)` | n/a | yes |
| <a name="input_sec_pm_api_url"></a> [sec\_pm\_api\_url](#input\_sec\_pm\_api\_url) | n/a | `string` | `""` | no |
| <a name="input_sec_pm_otp"></a> [sec\_pm\_otp](#input\_sec\_pm\_otp) | n/a | `string` | `null` | no |
| <a name="input_sec_pm_password"></a> [sec\_pm\_password](#input\_sec\_pm\_password) | n/a | `string` | `""` | no |
| <a name="input_sec_pm_tls_insecure"></a> [sec\_pm\_tls\_insecure](#input\_sec\_pm\_tls\_insecure) | n/a | `bool` | `true` | no |
| <a name="input_sec_pm_user"></a> [sec\_pm\_user](#input\_sec\_pm\_user) | n/a | `string` | `""` | no |
| <a name="input_subnet"></a> [subnet](#input\_subnet) | n/a | `string` | `"192.168.1.1/24"` | no |
| <a name="input_subnet_mask"></a> [subnet\_mask](#input\_subnet\_mask) | n/a | `string` | `"24"` | no |
| <a name="input_vm_boot"></a> [vm\_boot](#input\_vm\_boot) | n/a | `string` | `"c"` | no |
| <a name="input_vm_cpu_type"></a> [vm\_cpu\_type](#input\_vm\_cpu\_type) | n/a | `string` | `"host"` | no |
| <a name="input_vm_pool"></a> [vm\_pool](#input\_vm\_pool) | n/a | `string` | `null` | no |
| <a name="input_vm_sockets"></a> [vm\_sockets](#input\_vm\_sockets) | n/a | `number` | `1` | no |
| <a name="input_vm_target_node"></a> [vm\_target\_node](#input\_vm\_target\_node) | deprecated | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_masters"></a> [masters](#output\_masters) | n/a |
| <a name="output_workers"></a> [workers](#output\_workers) | n/a |
<!-- END_TF_DOCS -->
