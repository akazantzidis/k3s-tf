resource "random_shuffle" "random_node" {
  input        = var.proxmox_nodes
  result_count = 1
}
