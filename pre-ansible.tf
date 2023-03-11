resource "null_resource" "start" {
  count = var.exec_ansible ? 1 : 0
  depends_on = [
    proxmox_vm_qemu.master,
    proxmox_vm_qemu.worker
  ]
}

resource "null_resource" "sleep_pre_ansible" {
  count = var.exec_ansible ? 1 : 0
  provisioner "local-exec" {
    command = "sleep 180"
  }
  depends_on = [
    null_resource.start
  ]
}

# generate group vars for k8s cluster
resource "local_file" "kubernetes_k3s" {
  count           = var.exec_ansible ? 1 : 0
  content         = templatefile("${path.module}/templates/kubernetes/k3s.tmpl", {})
  filename        = "ansible/inventory/group_vars/kubernetes/k3s.yml"
  file_permission = "644"

  depends_on = [
    null_resource.sleep_pre_ansible
  ]
}

# generate group vars for k8s masters
resource "local_file" "kubernetes_k3s_masters" {
  count           = var.exec_ansible ? 1 : 0
  content         = templatefile("${path.module}/templates/master/k3s.tmpl", {})
  filename        = "ansible/inventory/group_vars/master/k3s.yml"
  file_permission = "644"
  depends_on = [
    local_file.kubernetes_k3s
  ]
}

# generate group vars for k8s workers
resource "local_file" "kubernetes_k3s_workers" {
  count           = var.exec_ansible ? 1 : 0
  content         = templatefile("${path.module}/templates/worker/k3s.tmpl", {})
  filename        = "ansible/inventory/group_vars/worker/k3s.yml"
  file_permission = "644"
  depends_on = [
    local_file.kubernetes_k3s_masters
  ]
}

# generate inventory file for Ansible
resource "local_file" "inventory" {
  count = var.exec_ansible ? 1 : 0
  content = templatefile("${path.module}/templates/inventory.tmpl",
    {
      masters = [for vm in proxmox_vm_qemu.master : { "name" = vm.name, "ipaddress" = vm.default_ipv4_address, "user" = vm.ssh_user }]
      workers = [for vm in proxmox_vm_qemu.worker : { "name" = vm.name, "ipaddress" = vm.default_ipv4_address, "user" = vm.ssh_user }]
    }

  )
  filename        = "ansible/inventory/hosts.yaml"
  file_permission = "644"
  depends_on = [
    local_file.kubernetes_k3s_workers
  ]
}

# generate ansible requirements file
resource "local_file" "ansible_requirements" {
  count           = var.exec_ansible ? 1 : 0
  content         = templatefile("${path.module}/templates/requirements.tmpl", {})
  filename        = "ansible/requirements.yaml"
  file_permission = "644"
  depends_on = [
    local_file.inventory
  ]
  lifecycle {
    ignore_changes = []
  }
}

# generate roles folder
resource "local_file" "ansible_roles_folder" {
  count           = var.exec_ansible ? 1 : 0
  content         = ""
  filename        = "ansible/roles/placeholder"
  file_permission = "644"
  depends_on = [
    local_file.ansible_requirements
  ]
  lifecycle {
    ignore_changes = []
  }
}

# generate playbook
resource "local_file" "generate_install_playbook" {
  count           = var.exec_ansible ? 1 : 0
  content         = templatefile("${path.module}/templates/k3s-install.tmpl", {})
  filename        = "ansible/playbooks/k3s-install.yaml"
  file_permission = "644"
  depends_on = [
    local_file.ansible_roles_folder
  ]
  lifecycle {
    ignore_changes = []
  }
}

# generate ansible.cfg
resource "local_file" "generate_ansible_cfg" {
  count           = var.exec_ansible ? 1 : 0
  content         = templatefile("${path.module}/templates/ansible.cfg.tmpl", {})
  filename        = "ansible/ansible.cfg"
  file_permission = "644"
  depends_on = [
    local_file.generate_install_playbook
  ]
}

# install ansible requirements
resource "null_resource" "install_ansible_galaxy_requirements" {
  count = var.exec_ansible ? 1 : 0
  provisioner "local-exec" {
    command = "ansible-galaxy install -r ansible/requirements.yaml"
  }
  depends_on = [
    local_file.generate_install_playbook
  ]
  lifecycle {
    ignore_changes = []
  }
}
