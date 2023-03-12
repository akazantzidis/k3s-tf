resource "null_resource" "start" {
  count = var.config_ansible ? 1 : 0
  depends_on = [
    proxmox_vm_qemu.master,
    proxmox_vm_qemu.worker
  ]
}

resource "time_sleep" "sleep_pre_ansible" {
  count           = var.config_ansible ? 1 : 0
  create_duration = "30s"
  depends_on = [
    null_resource.start
  ]
}

# generate inventory file for Ansible
resource "local_file" "inventory" {
  count = var.config_ansible ? 1 : 0
  content = templatefile("${path.module}/templates/inventory.tmpl",
    {
      masters = [for vm in proxmox_vm_qemu.master : { "name" = vm.name, "ipaddress" = vm.default_ipv4_address, "user" = vm.ssh_user }]
      workers = [for vm in proxmox_vm_qemu.worker : { "name" = vm.name, "ipaddress" = vm.default_ipv4_address, "user" = vm.ssh_user }]
    }
  )
  filename        = "ansible/inventory/hosts.yaml"
  file_permission = "644"
  depends_on = [
    time_sleep.sleep_pre_ansible
  ]
}

# generate ansible requirements file
resource "local_file" "ansible_requirements" {
  count           = var.config_ansible ? 1 : 0
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
  count           = var.config_ansible ? 1 : 0
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

# generate ansible.cfg
resource "local_file" "generate_ansible_cfg" {
  count           = var.config_ansible ? 1 : 0
  content         = templatefile("${path.module}/templates/ansible.cfg.tmpl", {})
  filename        = "./ansible.cfg"
  file_permission = "644"
  depends_on = [
    local_file.ansible_roles_folder
  ]
}

# install ansible requirements
resource "null_resource" "install_ansible_galaxy_requirements" {
  count = var.config_ansible ? 1 : 0
  provisioner "local-exec" {
    command = "ansible-galaxy install -r ansible/requirements.yaml"
  }
  depends_on = [
    local_file.generate_ansible_cfg
  ]
  lifecycle {
    ignore_changes = []
  }
}
