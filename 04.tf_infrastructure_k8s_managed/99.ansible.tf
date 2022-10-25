resource "local_file" "inventory" {
  filename = "../05.ansible/inventory/inventory.yaml"
  content  = <<-EOT
---
all:
  hosts:
# db-master
%{ for node in yandex_compute_instance.db-master ~} 
    ${node.hostname}:
      ansible_host: ${node.network_interface.0.nat_ip_address}
%{endfor~}
# db-slave
%{ for node in yandex_compute_instance.db-slave ~} 
    ${node.hostname}:
      ansible_host: ${node.network_interface.0.nat_ip_address}
%{endfor~}
# service-instance
%{ for node in yandex_compute_instance.service-instance ~} 
    ${node.hostname}:
      ansible_host: ${node.network_interface.0.nat_ip_address}
%{endfor~}
# nat
    ${yandex_compute_instance.nat.hostname}:
      ansible_host: ${yandex_compute_instance.nat.network_interface.0.nat_ip_address}

  vars:
    ansible_connection_type: paramiko
    ansible_user: dotsenkois


etcd_cluster:
  hosts:
%{ for node in yandex_compute_instance.db-master ~} 
    ${node.hostname}:
      ansible_host: ${node.network_interface.0.nat_ip_address}
%{endfor~}
%{ for node in yandex_compute_instance.db-slave ~} 
    ${node.hostname}:
      ansible_host: ${node.network_interface.0.nat_ip_address}
%{endfor~}

balancers:
  hosts:
%{ for node in yandex_compute_instance.db-master ~} 
    ${node.hostname}:
      ansible_host: ${node.network_interface.0.nat_ip_address}
%{endfor~}
%{ for node in yandex_compute_instance.db-slave ~} 
    ${node.hostname}:
      ansible_host: ${node.network_interface.0.nat_ip_address}
%{endfor~}

postgres_cluster:
  children:
    master:
      hosts:
%{ for node in yandex_compute_instance.db-master ~} 
    ${node.hostname}:
%{endfor~}
    replica:
      hosts:
%{ for node in yandex_compute_instance.db-slave ~} 
    ${node.hostname}:
%{endfor~}

service-instance:
  children:
    service-instance:
%{ for node in yandex_compute_instance.service-instance ~} 
    ${node.hostname}:
      ansible_host: ${node.network_interface.0.nat_ip_address}
%{endfor~}

EOT

  depends_on = [
    yandex_compute_instance.db-master,
    yandex_compute_instance.db-slave,
    yandex_compute_instance.nat,
    yandex_compute_instance.service-instance,
    yandex_compute_instance.jenkins-instance,
  ]
}


resource "null_resource" "run-ansible" {
  provisioner "local-exec" {
    command = "../05.ansible/security.sh; ../05.ansible/pg.sh; "
  }
depends_on = [
  local_file.inventory
]
  }

