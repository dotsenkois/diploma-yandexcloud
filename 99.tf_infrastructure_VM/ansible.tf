resource "null_resource" "wait" {
  provisioner "local-exec" {
    command = "sleep 50"
  }

  depends_on = [
    local_file.inventory
  ]
}

resource "null_resource" "roles" {
  provisioner "local-exec" {
    # command = "ansible-galaxy role install -r ../playbook/requirements.yml -f && ANSIBLE_FORCE_COLOR=1 ansible-playbook -i ../playbook/inventory/prod/hosts.yml ../playbook/site.yml"
    command = "ANSIBLE_FORCE_COLOR=1 ansible-playbook -i ../99.kubespray/inventory/netology/inventory.yml --become --become-user=root ../99.kubespray/cluster.yml"
  }

  depends_on = [
    null_resource.wait
  ]
}
