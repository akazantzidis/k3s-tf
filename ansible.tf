# execute ansible to create k8s cluster
resource "null_resource" "install_k3s_cluster" {
  count = var.exec_ansible ? 1 : 0
  provisioner "local-exec" {
    command = "ansible-playbook -i ansible/inventory/hosts.yaml ansible/playbooks/k3s-install.yaml"
  }
  depends_on = [
    null_resource.install_ansible_galaxy_requirements
  ]
  lifecycle {
    replace_triggered_by = [
      local_file.inventory,
      local_file.kubernetes_k3s,
      local_file.kubernetes_k3s_masters,
      local_file.kubernetes_k3s_workers,
      local_file.generate_install_playbook
    ]
  }
}
