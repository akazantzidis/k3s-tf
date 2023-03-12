resource "time_sleep" "sleep_pre_harden" {
  count           = alltrue([var.config_ansible, var.exec_harden]) ? 1 : 0
  create_duration = "120s"
  depends_on = [
    null_resource.install_ansible_galaxy_requirements
  ]
}

resource "null_resource" "start_hardening" {
  count = alltrue([var.config_ansible, var.exec_harden]) ? 1 : 0
  depends_on = [
    time_sleep.sleep_pre_harden
  ]
}

resource "local_file" "harden_role_create" {
  count           = alltrue([var.config_ansible, var.exec_harden]) ? 1 : 0
  content         = templatefile("${path.module}/templates/host-hardening.tmpl", {})
  filename        = "ansible/playbooks/host-hardening.yml"
  file_permission = "644"

  depends_on = [
    null_resource.start_hardening
  ]
}


resource "null_resource" "host_harden" {
  count = alltrue([var.config_ansible, var.exec_harden]) ? 1 : 0
  provisioner "local-exec" {
    command = "ansible-playbook -i ansible/inventory/hosts.yaml ansible/playbooks/host-hardening.yml"
  }
  depends_on = [
    local_file.harden_role_create,
    time_sleep.sleep_pre_harden
  ]
  lifecycle {
    replace_triggered_by = [
      local_file.inventory,
      proxmox_vm_qemu.master,
      proxmox_vm_qemu.worker
    ]
  }
}

resource "null_resource" "end_hardening" {
  count = alltrue([var.config_ansible, var.exec_harden]) ? 1 : 0
  depends_on = [
    null_resource.host_harden
  ]
}
