resource "yandex_compute_instance" "jenkins" {
  name        = "jenkins"
  hostname = "jenkins"
  platform_id = "standard-v1"
  zone        = "ru-central1-a"
  allow_stopping_for_update = true


  
  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8hsakek5tqhtca63mj"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.k8s-private-zone-a.id
    ip_address = "192.168.10.155"
    nat       = true
  }

  metadata = {
    user-data = file("${path.module}/cloud_config.yaml")
  }

  scheduling_policy {
    preemptible = "true"
  }
}



