resource "yandex_compute_instance" "gitlab-instance" {
  name        = "gitlab"
  hostname = "gitlab"
  platform_id = "standard-v1"
  zone        = "ru-central1-a"
  allow_stopping_for_update = true

  resources {
    cores  = local.workspaces[terraform.workspace].gitlab.resources.cores
    memory = local.workspaces[terraform.workspace].gitlab.resources.memory
    core_fraction = local.workspaces[terraform.workspace].gitlab.resources.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = local.workspaces[terraform.workspace].gitlab.boot_disk.image_id
      type = local.workspaces[terraform.workspace].gitlab.boot_disk.type
      size = local.workspaces[terraform.workspace].gitlab.boot_disk.size
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.jenkins-subnet.id
    ip_address = "192.168.10.151"
    nat       = true
  }

  metadata = {
    user-data = file("${path.module}/10.jenkins-cloud_config.yaml")
  }

  scheduling_policy {
    preemptible = local.workspaces[terraform.workspace].gitlab.scheduling_policy.preemptible

  }
}
