resource "yandex_compute_instance" "jenkins-instance" {
  name        = "jenkins"
  hostname = "jenkins"
  platform_id = "standard-v1"
  zone        = "ru-central1-a"
  allow_stopping_for_update = true

  resources {
    cores  = 2
    memory = 8
  }

  boot_disk {
    initialize_params {
      image_id = "fd8hsakek5tqhtca63mj"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.jenkins-subnet.id
    ip_address = "192.168.10.150"
    nat       = true
  }

  metadata = {
    user-data = file("${path.module}/10.jenkins-cloud_config.yaml")
  }

  scheduling_policy {
    preemptible = "true"
  }
}
