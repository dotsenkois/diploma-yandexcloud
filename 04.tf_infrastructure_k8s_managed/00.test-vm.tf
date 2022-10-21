resource "yandex_compute_instance" "docker" {
  name        = "docker"
  hostname = "docker"
  platform_id = "standard-v1"
  zone        = "ru-central1-a"
  allow_stopping_for_update = true

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8kb72eo1r5fs97a1ki"
      size = 30
      type = "network-ssd"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.nat-snet.id
    ip_address = "192.168.40.175"
    nat       = true
  }

  metadata = {
    # ssh-keys = "dotsenkois:${file("~/.ssh/id_rsa.pub")}"
    user-data = file("${path.module}/00.test-vm-cloud_config.yaml")

  }

  scheduling_policy {
    preemptible = "true"
  }
}
