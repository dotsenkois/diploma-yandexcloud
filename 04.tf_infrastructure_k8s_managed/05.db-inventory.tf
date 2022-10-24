resource "local_file" "inventory-db" {
  filename = var.HostsPath
  content  = <<-EOT
---
all:
  hosts:
%{ for node in yandex_compute_instance.db-master ~} 
    ${node.hostname}:
      ansible_host: ${node.network_interface.0.nat_ip_address}
%{endfor~}
%{ for node in yandex_compute_instance.db-slave ~} 
    ${node.hostname}:
      ansible_host: ${node.network_interface.0.nat_ip_address}
%{endfor~}

  vars:
    ansible_connection_type: paramiko
    ansible_user: root


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


EOT

  depends_on = [
    yandex_compute_instance.db-master,
    yandex_compute_instance.db-slave,

  ]
}
