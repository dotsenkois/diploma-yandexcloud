resource "yandex_compute_instance" "service-instance" {
  name        = "remote"
  hostname    = "remote"
  description = "For remote access"
  folder_id = local.folder_id
  allow_stopping_for_update = true

  resources {
    cores         = local.service-instance_resources.cores
    memory        = local.service-instance_resources.memory
    core_fraction = local.service-instance_resources.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = local.service-instance_boot_disk.image_id
      type     = local.service-instance_boot_disk.type
      size     = local.service-instance_boot_disk.size
    }
  }

  # metadata = {
  #   ssh-keys = "centos:${file("~/.ssh/id_rsa.pub")}"
  # }
  metadata = {
    user-data = file("${path.module}/01.service-instance-cloud_config.yaml")
    # ssh-keys = "${var.ssh_user}:${file(var.ssh_pub_key)}"
    serial-port-enable = "1"
  }
  scheduling_policy {
    preemptible = local.service-instance_scheduling_policy.preemptible
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.ansible-service-subnet.id
    nat       = "true"
    ip_address = "192.168.11.20"
  }

  depends_on = [
    yandex_storage_object.terraform, 
  ]
}

resource "yandex_vpc_network" "ansible-service-network" {
  name = "ansible-service-network"
}

resource "yandex_vpc_subnet" "ansible-service-subnet" {
  name = "ansible-service-subnet"
  v4_cidr_blocks = ["192.168.11.0/24"]
  zone           = "ru-central1-a"
  network_id =  yandex_vpc_network.ansible-service-network.id
}


resource "local_file" "inventory" {
  file_permission = "644"
  filename = "./ansible/inventory/inventory.yaml"
  content  = <<-EOT
---
all:
  hosts:
    ${yandex_compute_instance.service-instance.hostname}:
      ansible_host: ${yandex_compute_instance.service-instance.network_interface.0.nat_ip_address}
  vars:
    ansible_connection_type: paramiko
    ansible_user: dotsenkois

    service-instance:
    ${yandex_compute_instance.service-instance.hostname}:
      ansible_host: ${yandex_compute_instance.service-instance.network_interface.0.nat_ip_address}

EOT

  depends_on = [
    yandex_compute_instance.service-instance,
  ]
}

resource "null_resource" "sleep" {
  provisioner "local-exec" {
    command = "sleep 50"
  }
depends_on = [
  local_file.inventory
]
  }

resource "null_resource" "run-ansible" {
  provisioner "local-exec" {
    command = "ansible-playbook -i ./ansible/inventory/inventory.yaml ./ansible/site.yaml --private-key ~/.ssh/netology"
  }
depends_on = [
  null_resource.sleep
]
  }







