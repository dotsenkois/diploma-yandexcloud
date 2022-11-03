resource "yandex_compute_instance" "teamcity-instance" {
  name        = "teamcity-instance"
  hostname = "teamcity-instance"
  platform_id = "standard-v1"
  zone        = "ru-central1-a"
  allow_stopping_for_update = true

  resources {
    cores  = local.workspaces[terraform.workspace].teamcity.resources.cores
    memory = local.workspaces[terraform.workspace].teamcity.resources.memory
    core_fraction = local.workspaces[terraform.workspace].teamcity.resources.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = local.workspaces[terraform.workspace].teamcity.boot_disk.image_id
      type = local.workspaces[terraform.workspace].teamcity.boot_disk.type
      size = local.workspaces[terraform.workspace].teamcity.boot_disk.size
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.teamcity-subnet.id
    ip_address = "192.168.10.153"
    nat       = true
  }

  metadata = {
    user-data = file("${path.module}/10.teamcity-instance-cloud_config.yaml")
  }

  scheduling_policy {
    preemptible = local.workspaces[terraform.workspace].teamcity.scheduling_policy.preemptible

  }
}
