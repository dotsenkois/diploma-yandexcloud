resource "null_resource" "run_ansible" {
  provisioner "local-exec" {
    command = "ansible-playbook -i ../05.ansible-db/inventory/inventory.yml ../postgresql_cluster/deploy_pgcluster.yml"
  }
  }
