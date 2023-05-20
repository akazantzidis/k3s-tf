<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=0.13 |
| <a name="requirement_proxmox"></a> [proxmox](#requirement\_proxmox) | >=2.9.11 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_proxmox"></a> [proxmox](#provider\_proxmox) | >=2.9.11 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

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
| <a name="input_cloudinit_nameserver"></a> [cloudinit\_nameserver](#input\_cloudinit\_nameserver) | n/a | `string` | `null` | no |
| <a name="input_cloudinit_search_domain"></a> [cloudinit\_search\_domain](#input\_cloudinit\_search\_domain) | n/a | `string` | `null` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | n/a | `string` | `"default-cluster"` | no |
| <a name="input_gw"></a> [gw](#input\_gw) | n/a | `string` | `"192.168.1.1"` | no |
| <a name="input_ha_control_plane"></a> [ha\_control\_plane](#input\_ha\_control\_plane) | n/a | `bool` | `false` | no |
| <a name="input_k3s_cloud_controller_disable"></a> [k3s\_cloud\_controller\_disable](#input\_k3s\_cloud\_controller\_disable) | n/a | `bool` | `true` | no |
| <a name="input_k3s_cluster_cidr"></a> [k3s\_cluster\_cidr](#input\_k3s\_cluster\_cidr) | n/a | `string` | `"10.86.0.0/16"` | no |
| <a name="input_k3s_disable"></a> [k3s\_disable](#input\_k3s\_disable) | n/a | `list(string)` | <pre>[<br>  "traefik",<br>  "servicelb",<br>  "metrics-server",<br>  "local-storage"<br>]</pre> | no |
| <a name="input_k3s_flannel_backend"></a> [k3s\_flannel\_backend](#input\_k3s\_flannel\_backend) | n/a | `string` | `"vxlan"` | no |
| <a name="input_k3s_kube_apiserver_args"></a> [k3s\_kube\_apiserver\_args](#input\_k3s\_kube\_apiserver\_args) | n/a | `list(string)` | <pre>[<br>  "feature-gates=MixedProtocolLBService=true"<br>]</pre> | no |
| <a name="input_k3s_kube_control_manag_args"></a> [k3s\_kube\_control\_manag\_args](#input\_k3s\_kube\_control\_manag\_args) | n/a | `list(string)` | <pre>[<br>  "feature-gates=MixedProtocolLBService=true",<br>  "bind-address=0.0.0.0"<br>]</pre> | no |
| <a name="input_k3s_kube_proxy_args"></a> [k3s\_kube\_proxy\_args](#input\_k3s\_kube\_proxy\_args) | n/a | `list(string)` | <pre>[<br>  "feature-gates=MixedProtocolLBService=true",<br>  "bind-address=0.0.0.0"<br>]</pre> | no |
| <a name="input_k3s_kube_proxy_disable"></a> [k3s\_kube\_proxy\_disable](#input\_k3s\_kube\_proxy\_disable) | n/a | `bool` | `false` | no |
| <a name="input_k3s_kube_sched_args"></a> [k3s\_kube\_sched\_args](#input\_k3s\_kube\_sched\_args) | n/a | `list(string)` | <pre>[<br>  "feature-gates=MixedProtocolLBService=true",<br>  "bind-address=0.0.0.0"<br>]</pre> | no |
| <a name="input_k3s_master_kubelet_args"></a> [k3s\_master\_kubelet\_args](#input\_k3s\_master\_kubelet\_args) | n/a | `list(string)` | <pre>[<br>  "feature-gates=MixedProtocolLBService=true"<br>]</pre> | no |
| <a name="input_k3s_master_node_labels"></a> [k3s\_master\_node\_labels](#input\_k3s\_master\_node\_labels) | n/a | `list(string)` | `[]` | no |
| <a name="input_k3s_master_node_taints"></a> [k3s\_master\_node\_taints](#input\_k3s\_master\_node\_taints) | n/a | `list(string)` | <pre>[<br>  "k3s-controlplane=true:NoExecute",<br>  "CriticalAddonsOnly=true:NoExecute"<br>]</pre> | no |
| <a name="input_k3s_network_policy_disable"></a> [k3s\_network\_policy\_disable](#input\_k3s\_network\_policy\_disable) | n/a | `bool` | `false` | no |
| <a name="input_k3s_sans"></a> [k3s\_sans](#input\_k3s\_sans) | n/a | `list(string)` | <pre>[<br>  "k8s.local"<br>]</pre> | no |
| <a name="input_k3s_secrets_encryption_enable"></a> [k3s\_secrets\_encryption\_enable](#input\_k3s\_secrets\_encryption\_enable) | n/a | `bool` | `true` | no |
| <a name="input_k3s_service_cidr"></a> [k3s\_service\_cidr](#input\_k3s\_service\_cidr) | n/a | `string` | `"10.88.0.0/16"` | no |
| <a name="input_k3s_worker_kubelet_args"></a> [k3s\_worker\_kubelet\_args](#input\_k3s\_worker\_kubelet\_args) | n/a | `list(string)` | <pre>[<br>  "feature-gates=MixedProtocolLBService=true"<br>]</pre> | no |
| <a name="input_k3s_worker_node_labels"></a> [k3s\_worker\_node\_labels](#input\_k3s\_worker\_node\_labels) | n/a | `list(string)` | <pre>[<br>  "node.kubernetes.io/worker=true"<br>]</pre> | no |
| <a name="input_k3s_worker_node_taints"></a> [k3s\_worker\_node\_taints](#input\_k3s\_worker\_node\_taints) | n/a | `list(string)` | `[]` | no |
| <a name="input_k3s_worker_protect_kernel_defaults"></a> [k3s\_worker\_protect\_kernel\_defaults](#input\_k3s\_worker\_protect\_kernel\_defaults) | n/a | `bool` | `false` | no |
| <a name="input_k3s_worker_snapshotter"></a> [k3s\_worker\_snapshotter](#input\_k3s\_worker\_snapshotter) | n/a | `string` | `"native"` | no |
| <a name="input_k3s_write_kubeconfig_mode"></a> [k3s\_write\_kubeconfig\_mode](#input\_k3s\_write\_kubeconfig\_mode) | n/a | `string` | `"600"` | no |
| <a name="input_masters"></a> [masters](#input\_masters) | n/a | <pre>object({<br>    name      = optional(string, "control")<br>    node      = optional(string, "")<br>    pool      = optional(string, null)<br>    cores     = optional(number, 1)<br>    memory    = optional(number, 2048)<br>    bridge    = optional(string, "vmbr0")<br>    tag       = optional(number, -1)<br>    tags      = optional(list(string), ["terraform-managed-master"])<br>    ipconfig0 = optional(string, "")<br>    scsihw    = optional(string, "virtio-scsi-pci")<br>    disks = optional(list(object({<br>      id      = optional(number, 0)<br>      size    = optional(string, "10G")<br>      storage = optional(string, "local-lvm")<br>      type    = optional(string, "virtio")<br>      discard = optional(string, null)<br>      ssd = optional(number, 0) })), [<br>      {<br>        id   = 0<br>        size = "10G"<br>    }])<br>    image              = string<br>    ssh_user           = string<br>    user_password      = string<br>    ssh_keys           = string<br>    subnet             = string<br>    gw                 = string<br>    master_start_index = optional(string, "")<br>  })</pre> | n/a | yes |
| <a name="input_pools"></a> [pools](#input\_pools) | n/a | <pre>list(object({<br>    name      = optional(string, "node")<br>    workers   = optional(number, 1)<br>    node      = optional(string, "")<br>    pool      = optional(string, null)<br>    cores     = optional(number, 1)<br>    memory    = optional(number, 2048)<br>    bridge    = optional(string, "vmbr0")<br>    tag       = optional(number, -1)<br>    tags      = optional(list(string), ["terraform-managed-worker"])<br>    ipconfig0 = optional(string, "")<br>    scsihw    = optional(string, "virtio-scsi-pci")<br>    disks = optional(list(object({<br>      id      = optional(number, 0)<br>      size    = optional(string, "10G")<br>      storage = optional(string, "local-lvm")<br>      type    = optional(string, "virtio")<br>      discard = optional(string, null)<br>      ssd = optional(number, 0) })),<br>      [{<br>        id   = 0<br>        size = "10G"<br>    }])<br>    image              = string<br>    ssh_user           = string<br>    user_password      = string<br>    ssh_keys           = string<br>    subnet             = string<br>    gw                 = string<br>    worker_start_index = optional(string, "")<br>  }))</pre> | n/a | yes |
| <a name="input_private_ssh_key"></a> [private\_ssh\_key](#input\_private\_ssh\_key) | The path is stored the private ssh key which matches the ssh authorized keys which were set | `string` | `"~/.ssh/id_ed25519"` | no |
| <a name="input_proxmox_nodes"></a> [proxmox\_nodes](#input\_proxmox\_nodes) | n/a | `list(string)` | n/a | yes |
| <a name="input_subnet"></a> [subnet](#input\_subnet) | n/a | `string` | `"192.168.1.1/24"` | no |
| <a name="input_vm_boot"></a> [vm\_boot](#input\_vm\_boot) | n/a | `string` | `"order=virtio0"` | no |
| <a name="input_vm_cpu_type"></a> [vm\_cpu\_type](#input\_vm\_cpu\_type) | n/a | `string` | `"host"` | no |
| <a name="input_vm_sockets"></a> [vm\_sockets](#input\_vm\_sockets) | n/a | `number` | `1` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_masters"></a> [masters](#output\_masters) | n/a |
| <a name="output_workers"></a> [workers](#output\_workers) | n/a |
<!-- END_TF_DOCS -->
