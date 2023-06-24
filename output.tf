
output "masters" {
  value = [for vm in proxmox_vm_qemu.master : { "name" = vm.name, "ipaddress" = vm.default_ipv4_address }]
}

output "workers" {
  value = [for vm in proxmox_vm_qemu.worker : { "name" = vm.name, "ipaddress" = vm.default_ipv4_address }]
}
