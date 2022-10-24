resource "yandex_compute_instance" "nat" {
  name        = "nat"
  hostname = "nat"
  platform_id = "standard-v1"
  zone        = "ru-central1-a"
  allow_stopping_for_update = true

  resources {
    cores  = 2
    memory = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = "fd83slullt763d3lo57m"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.nat-subnet.id
    ip_address = "192.168.10.116"
    nat       = true
  }

  metadata = {
    user-data = file("${path.module}/01.nat-instance-cloud_config.yaml")
  }

  scheduling_policy {
    preemptible = "true"
  }
}
