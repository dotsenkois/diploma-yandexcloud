
resource "yandex_compute_instance" "service-instance" {

  count       = local.workspaces[terraform.workspace].service-instance_count
  name        = format("service-instance-%03d", count.index +1)
  # platform_id = var.yc_instances_control-plane
  hostname    = format("service-instance-%03d", count.index +1)
  description = "CP node for diplom demonstration"

  resources {
    cores         = local.workspaces[terraform.workspace].service-instance_resources.cores
    memory        = local.workspaces[terraform.workspace].service-instance_resources.memory
    core_fraction = local.workspaces[terraform.workspace].service-instance_resources.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = local.workspaces[terraform.workspace].service-instance_boot_disk.image_id
      type     = local.workspaces[terraform.workspace].service-instance_boot_disk.type
      size     = local.workspaces[terraform.workspace].service-instance_boot_disk.size
    }
  }
  metadata = {
    user-data = file("${path.module}/01.service-instanse-cloud_config.yaml")
  }
  scheduling_policy {
    preemptible = local.workspaces[terraform.workspace].service-instance_scheduling_policy.preemptible
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.service-subnet.id
    ip_address = format("192.168.10.%d", count.index + 135)
    nat       = "true"
  }
}