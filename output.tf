
output "masters" {
  value       = [for vm in proxmox_vm_qemu.master : { "name" = vm.name, "ipaddress" = vm.default_ipv4_address }]
  description = "Returns a list including each master object name and ip"
}

output "workers" {
  value       = [for vm in proxmox_vm_qemu.worker : { "name" = vm.name, "ipaddress" = vm.default_ipv4_address }]
  description = "Returns a list including each node object name and ip"
}
