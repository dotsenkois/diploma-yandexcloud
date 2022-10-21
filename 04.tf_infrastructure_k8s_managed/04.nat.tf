resource "yandex_compute_instance" "nat" {
  name        = "nat"
  hostname = "nat"
  platform_id = "standard-v1"
  zone        = "ru-central1-a"
  allow_stopping_for_update = true


  
  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd83slullt763d3lo57m"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.nat-snet.id
    ip_address = "192.168.40.11"
    nat       = true
  }

  metadata = {
    user-data = file("${path.module}/cloud_config.yaml")
  }

  scheduling_policy {
    preemptible = "true"
  }
}


resource "null_resource" "wait" {
  provisioner "local-exec" {
    command = "sleep 50"
  }
}

# resource "null_resource" "copy_rsa" {
#   provisioner "local-exec" {
#     command = "scp ~/.ssh/id_rsa dotsenkois@${yandex_compute_instance.nat.network_interface.0.nat_ip_address}:~/.ssh/"

#   }

#   depends_on = [
#     null_resource.wait
#   ]
# }

