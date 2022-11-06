resource "yandex_compute_instance" "jenkins-instance" {
  name        = "jenkins"
  hostname = "jenkins"
  platform_id = "standard-v1"
  zone        = "ru-central1-a"
  allow_stopping_for_update = true
  service_account_id = yandex_iam_service_account.jenkins-sa.id

  resources {
    cores  = local.workspaces[terraform.workspace].jenkins.resources.cores
    memory = local.workspaces[terraform.workspace].jenkins.resources.memory
    core_fraction = local.workspaces[terraform.workspace].jenkins.resources.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = local.workspaces[terraform.workspace].jenkins.boot_disk.image_id
      type = local.workspaces[terraform.workspace].jenkins.boot_disk.type
      size = local.workspaces[terraform.workspace].jenkins.boot_disk.size
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.CICD-subnet.id
    ip_address = "192.168.10.152"
    nat       = true
  }

  metadata = {
    user-data = file("${path.module}/10.jenkins-cloud_config.yaml")
  }

  scheduling_policy {
    preemptible = local.workspaces[terraform.workspace].jenkins.scheduling_policy.preemptible

  }
  depends_on = [
    yandex_container_registry.my-reg,
  ]

}

resource "local_file" "jenkins-instance-inventory" {
  filename = "../07.CICD/inventory.yaml"
  content  = <<-EOT
---
all:
  hosts:
    ${yandex_compute_instance.jenkins-instance.hostname}:
      ansible_host: ${yandex_compute_instance.jenkins-instance.network_interface.0.nat_ip_address}

  vars:
    ansible_connection_type: paramiko
    ansible_user: dotsenkois

jenkins-master:
  hosts:
    ${yandex_compute_instance.jenkins-instance.hostname}:
EOT

  depends_on = [
    yandex_compute_instance.jenkins-instance,
  ]
}


resource "null_resource" "jenkins-instance-run-ansible" {
  provisioner "local-exec" {
    command = "sleep 60 && ANSIBLE_FORCE_COLOR=1 ansible-playbook -i ../07.CICD/inventory.yaml ../07.CICD/site.yaml --private-key ~/.ssh/netology"
  }
depends_on = [
  local_file.jenkins-instance-inventory
]
  }

