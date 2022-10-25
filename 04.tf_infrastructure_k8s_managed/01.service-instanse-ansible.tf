# resource "local_file" "service-instanse-ansible" {
#   filename = "../05.service-instanse-ansible/inventory.yaml"
#   content  = <<-EOT
# ---
# all:
#   hosts:
# %{ for node in yandex_compute_instance.service-instance ~} 
#     ${node.hostname}:
#       ansible_host: ${node.network_interface.0.nat_ip_address}
# %{endfor~}
#   vars:
#     ansible_connection_type: paramiko
#     ansible_user: dotsenkois
# EOT

#   depends_on = [
#     yandex_compute_instance.service-instance,
#   ]
# }


# resource "null_resource" "run_service-instanse-ansible" {
#   provisioner "local-exec" {
#     command = "ansible-playbook -i ../05.service-instanse-ansible/inventory.yaml ../05.service-instanse-ansible/site.yaml"
#   }
# depends_on = [
#   local_file.service-instanse-ansible
# ]
#   }
