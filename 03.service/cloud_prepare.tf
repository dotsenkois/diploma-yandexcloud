resource "yandex_compute_instance" "ansible-service-instance" {
  name        = "remote"
  hostname    = "remote"
  description = "For remote"
  folder_id = local.buket_folder_id

  resources {
    cores         = local.ansible-service-instance_resources.cores
    memory        = local.ansible-service-instance_resources.memory
    core_fraction = local.ansible-service-instance_resources.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = local.ansible-service-instance_boot_disk.image_id
      type     = local.ansible-service-instance_boot_disk.type
      size     = local.ansible-service-instance_boot_disk.size
    }
  }
  metadata = {
    ssh-keys = "sa:${file("../sa_rsa.pub")}"
    user-data = file("${path.module}/ansible-service-instance-cloud_config.yaml")
  }
  scheduling_policy {
    preemptible = local.ansible-service-instance_scheduling_policy.preemptible
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.ansible-service-subnet.id
    nat       = "true"
    ip_address = "192.168.10.20"
  }
}

resource "yandex_vpc_network" "ansible-service-network" {
  name = "ansible-service-network"
}

resource "yandex_vpc_subnet" "ansible-service-subnet" {
  name = "ansible-service-subnet"
  v4_cidr_blocks = ["192.168.10.0/24"]
  zone           = "ru-central1-a"
  network_id =  yandex_vpc_network.ansible-service-network.id
}









