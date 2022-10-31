resource "yandex_compute_instance" "VPN" {
  name        = "vpn-gate"
  platform_id = "standard-v1"
  zone        = "ru-central1-a"
  hostname    = "vpn-gate"
  allow_stopping_for_update = true

  resources {
    cores  = 2
    memory = 2
    core_fraction = 5
  }

  boot_disk {
    initialize_params {
      image_id = "fd8e6a9c1klmji7decok"
      size =  5
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.nat-subnet.id
    ip_address = "192.168.10.117"
    nat       = true
  }

  metadata = {
    user-data = file("${path.module}/00.VPN-instance-cloud_config.yaml")
  }
  scheduling_policy {
    preemptible = "false"
  }
}