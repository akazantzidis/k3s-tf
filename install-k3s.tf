# generate group vars for k8s cluster
resource "local_file" "kubernetes_k3s" {
  count           = alltrue([var.config_ansible, var.install_k3s]) ? 1 : 0
  content         = templatefile("${path.module}/templates/kubernetes/k3s.tmpl", {})
  filename        = "ansible/inventory/group_vars/kubernetes/k3s.yml"
  file_permission = "644"

  depends_on = [
    null_resource.install_ansible_galaxy_requirements
  ]
}

# generate group vars for k8s masters
resource "local_file" "kubernetes_k3s_masters" {
  count           = alltrue([var.config_ansible, var.install_k3s]) ? 1 : 0
  content         = templatefile("${path.module}/templates/master/k3s.tmpl", {})
  filename        = "ansible/inventory/group_vars/master/k3s.yml"
  file_permission = "644"
  depends_on = [
    local_file.kubernetes_k3s
  ]
}

# generate group vars for k8s workers
resource "local_file" "kubernetes_k3s_workers" {
  count           = alltrue([var.config_ansible, var.install_k3s]) ? 1 : 0
  content         = templatefile("${path.module}/templates/worker/k3s.tmpl", {})
  filename        = "ansible/inventory/group_vars/worker/k3s.yml"
  file_permission = "644"
  depends_on = [
    local_file.kubernetes_k3s_masters
  ]
}

# generate playbook
resource "local_file" "generate_install_playbook" {
  count           = alltrue([var.config_ansible, var.install_k3s]) ? 1 : 0
  content         = templatefile("${path.module}/templates/k3s-install.tmpl", {})
  filename        = "ansible/playbooks/k3s-install.yaml"
  file_permission = "644"
  depends_on = [
    local_file.kubernetes_k3s_workers
  ]
  lifecycle {
    ignore_changes = []
  }
}

# execute ansible to create k8s cluster
resource "null_resource" "install_k3s_cluster" {
  count = alltrue([var.config_ansible, var.install_k3s]) ? 1 : 0
  provisioner "local-exec" {
    command = "ansible-playbook -i ansible/inventory/hosts.yaml ansible/playbooks/k3s-install.yaml"
  }
  depends_on = [
    local_file.generate_install_playbook
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
