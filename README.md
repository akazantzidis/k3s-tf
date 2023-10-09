<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=0.13 |
| <a name="requirement_proxmox"></a> [proxmox](#requirement\_proxmox) | >=2.9.11 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_proxmox"></a> [proxmox](#provider\_proxmox) | 2.9.14 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.5.1 |

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
| <a name="input_api_vip"></a> [api\_vip](#input\_api\_vip) | VIP ip address for k8s api.Can be an existing infrastructure loadbalancer. | `string` | `""` | no |
| <a name="input_cilium"></a> [cilium](#input\_cilium) | Install Cillium cni | `bool` | `false` | no |
| <a name="input_cilium_helm_flags"></a> [cilium\_helm\_flags](#input\_cilium\_helm\_flags) | Cillium helm arguments delimited with ','.Example key1=value,key2=value | `string` | `"k8sServicePort=6443,ipam.mode=kubernetes,operator.replicas=1"` | no |
| <a name="input_cilium_version"></a> [cilium\_version](#input\_cilium\_version) | Cillium version to install.Example 1.13.2 | `string` | `""` | no |
| <a name="input_cloudinit_nameserver"></a> [cloudinit\_nameserver](#input\_cloudinit\_nameserver) | VM's DNS server | `string` | `null` | no |
| <a name="input_cloudinit_search_domain"></a> [cloudinit\_search\_domain](#input\_cloudinit\_search\_domain) | VM's DNS domain search | `string` | `null` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Cluster name. | `string` | `"default-cluster"` | no |
| <a name="input_ha_control_plane"></a> [ha\_control\_plane](#input\_ha\_control\_plane) | Set HA for K3S control plane.If HA true then 3 master nodes are provisioned. | `bool` | `false` | no |
| <a name="input_k3s_cloud_controller_disable"></a> [k3s\_cloud\_controller\_disable](#input\_k3s\_cloud\_controller\_disable) | k3s default network cloud controller configuration | `bool` | `true` | no |
| <a name="input_k3s_cluster_cidr"></a> [k3s\_cluster\_cidr](#input\_k3s\_cluster\_cidr) | k3s cluster pod cidr configuration | `string` | `"10.86.0.0/16"` | no |
| <a name="input_k3s_disable"></a> [k3s\_disable](#input\_k3s\_disable) | k3s addons disable configuration | `list(string)` | `[]` | no |
| <a name="input_k3s_flannel_backend"></a> [k3s\_flannel\_backend](#input\_k3s\_flannel\_backend) | k3s default network backend configuration | `string` | `"vxlan"` | no |
| <a name="input_k3s_kube_apiserver_args"></a> [k3s\_kube\_apiserver\_args](#input\_k3s\_kube\_apiserver\_args) | k3s api server extra configuration | `list(string)` | `[]` | no |
| <a name="input_k3s_kube_control_manag_args"></a> [k3s\_kube\_control\_manag\_args](#input\_k3s\_kube\_control\_manag\_args) | k3s controller-manager extra configuration | `list(string)` | <pre>[<br>  "bind-address=0.0.0.0"<br>]</pre> | no |
| <a name="input_k3s_kube_proxy_args"></a> [k3s\_kube\_proxy\_args](#input\_k3s\_kube\_proxy\_args) | k3s kube-proxy extra configuration | `list(string)` | <pre>[<br>  "bind-address=0.0.0.0"<br>]</pre> | no |
| <a name="input_k3s_kube_proxy_disable"></a> [k3s\_kube\_proxy\_disable](#input\_k3s\_kube\_proxy\_disable) | k3s default kube-proxy configuration | `bool` | `false` | no |
| <a name="input_k3s_kube_sched_args"></a> [k3s\_kube\_sched\_args](#input\_k3s\_kube\_sched\_args) | k3s scheduler extra configuration | `list(string)` | <pre>[<br>  "bind-address=0.0.0.0"<br>]</pre> | no |
| <a name="input_k3s_master_kubelet_args"></a> [k3s\_master\_kubelet\_args](#input\_k3s\_master\_kubelet\_args) | k3s masters kubelet arguments | `list(string)` | `[]` | no |
| <a name="input_k3s_master_node_labels"></a> [k3s\_master\_node\_labels](#input\_k3s\_master\_node\_labels) | K3s master labels | `list(string)` | `[]` | no |
| <a name="input_k3s_master_node_taints"></a> [k3s\_master\_node\_taints](#input\_k3s\_master\_node\_taints) | k3s master taints | `list(string)` | `[]` | no |
| <a name="input_k3s_network_policy_disable"></a> [k3s\_network\_policy\_disable](#input\_k3s\_network\_policy\_disable) | k3s default network policy controller configuration | `bool` | `false` | no |
| <a name="input_k3s_sans"></a> [k3s\_sans](#input\_k3s\_sans) | K3s default certificate included entries configuration | `list(string)` | `null` | no |
| <a name="input_k3s_secrets_encryption_enable"></a> [k3s\_secrets\_encryption\_enable](#input\_k3s\_secrets\_encryption\_enable) | K3s default secrets encryption configuration | `bool` | `true` | no |
| <a name="input_k3s_service_cidr"></a> [k3s\_service\_cidr](#input\_k3s\_service\_cidr) | K3s cluster service cidr configuration | `string` | `"10.88.0.0/16"` | no |
| <a name="input_k3s_snapshotter"></a> [k3s\_snapshotter](#input\_k3s\_snapshotter) | k3s default snapshotter configuration | `string` | `"native"` | no |
| <a name="input_k3s_version"></a> [k3s\_version](#input\_k3s\_version) | The k3s version to be installed.Eg. vX.Y.Z-rc1 | `string` | `""` | no |
| <a name="input_k3s_worker_kubelet_args"></a> [k3s\_worker\_kubelet\_args](#input\_k3s\_worker\_kubelet\_args) | k3s workers kubelet arguments | `list(string)` | `[]` | no |
| <a name="input_k3s_worker_node_labels"></a> [k3s\_worker\_node\_labels](#input\_k3s\_worker\_node\_labels) | k3s worker labels | `list(string)` | `[]` | no |
| <a name="input_k3s_worker_node_taints"></a> [k3s\_worker\_node\_taints](#input\_k3s\_worker\_node\_taints) | k3s worker taints | `list(string)` | `[]` | no |
| <a name="input_k3s_worker_protect_kernel_defaults"></a> [k3s\_worker\_protect\_kernel\_defaults](#input\_k3s\_worker\_protect\_kernel\_defaults) | k3s protect kernel defaults configuration | `bool` | `false` | no |
| <a name="input_k3s_write_kubeconfig_mode"></a> [k3s\_write\_kubeconfig\_mode](#input\_k3s\_write\_kubeconfig\_mode) | K3s default kube-config configuration | `string` | `"640"` | no |
| <a name="input_kube_vip_dev"></a> [kube\_vip\_dev](#input\_kube\_vip\_dev) | n/a | `string` | `"eth0"` | no |
| <a name="input_kube_vip_enable"></a> [kube\_vip\_enable](#input\_kube\_vip\_enable) | n/a | `bool` | `false` | no |
| <a name="input_masters"></a> [masters](#input\_masters) | Master nodes configuration options | <pre>object({<br>    node   = optional(string, "")<br>    pool   = optional(string, null)<br>    cores  = optional(number, 1)<br>    memory = optional(number, 2048)<br>    bridge = optional(string, "vmbr0")<br>    tag    = optional(number, -1)<br>    tags   = optional(list(string), ["terraform-managed-master"])<br>    scsihw = optional(string, "virtio-scsi-pci")<br>    disks = optional(list(object({<br>      id      = optional(number, 0)<br>      size    = optional(string, "10G")<br>      storage = optional(string, "local-lvm")<br>      type    = optional(string, "virtio")<br>      discard = optional(string, null)<br>      ssd = optional(number, 0) })), [<br>      {<br>        id   = 0<br>        size = "10G"<br>    }])<br>    image              = string<br>    ssh_user           = string<br>    user_password      = string<br>    ssh_keys           = string<br>    subnet             = string<br>    gw                 = string<br>    master_start_index = optional(string, "")<br>  })</pre> | n/a | yes |
| <a name="input_pools"></a> [pools](#input\_pools) | Worker pools configuration options | <pre>list(object({<br>    name    = string<br>    workers = optional(number, 1)<br>    node    = optional(string, "")<br>    pool    = optional(string, null)<br>    cores   = optional(number, 1)<br>    memory  = optional(number, 2048)<br>    bridge  = optional(string, "vmbr0")<br>    tag     = optional(number, -1)<br>    tags    = optional(list(string), ["terraform-managed-worker"])<br>    scsihw  = optional(string, "virtio-scsi-pci")<br>    disks = optional(list(object({<br>      id      = optional(number, 0)<br>      size    = optional(string, "10G")<br>      storage = optional(string, "local-lvm")<br>      type    = optional(string, "virtio")<br>      discard = optional(string, null)<br>      ssd = optional(number, 0) })),<br>      [{<br>        id   = 0<br>        size = "10G"<br>    }])<br>    image              = string<br>    ssh_user           = string<br>    user_password      = string<br>    ssh_keys           = string<br>    subnet             = string<br>    gw                 = string<br>    worker_start_index = optional(string, "")<br>  }))</pre> | n/a | yes |
| <a name="input_private_ssh_key"></a> [private\_ssh\_key](#input\_private\_ssh\_key) | SSH private key to be used during provisioning.[The public one should exist in the nodes during provisioning] | `string` | n/a | yes |
| <a name="input_proxmox_nodes"></a> [proxmox\_nodes](#input\_proxmox\_nodes) | List of proxmox nodes availiable for k3s nodes setup. | `list(string)` | n/a | yes |
| <a name="input_vm_boot"></a> [vm\_boot](#input\_vm\_boot) | VM's boot device configuration | `string` | `"order=virtio0"` | no |
| <a name="input_vm_cpu_type"></a> [vm\_cpu\_type](#input\_vm\_cpu\_type) | VM's CPU type | `string` | `"host"` | no |
| <a name="input_vm_sockets"></a> [vm\_sockets](#input\_vm\_sockets) | VM's CPU sockets | `number` | `1` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_masters"></a> [masters](#output\_masters) | Returns a list including each master object name and ip |
| <a name="output_workers"></a> [workers](#output\_workers) | Returns a list including each node object name and ip |
<!-- END_TF_DOCS -->
