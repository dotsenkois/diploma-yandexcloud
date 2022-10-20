
resource "yandex_compute_instance" "db-master" {

  name        = format("db-node-%03d", count.index + 1)
  # platform_id = var.yc_instances_control-plane
  hostname    = format("db-node-%03d", count.index + 1)
  description = "CP node for diplom demonstration"
  count       = local.workspaces[terraform.workspace].db_nodes_count


  resources {
    cores         = local.workspaces[terraform.workspace].db_resources.cores
    memory        = local.workspaces[terraform.workspace].db_resources.memory
    core_fraction = local.workspaces[terraform.workspace].db_resources.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = local.workspaces[terraform.workspace].db_boot_disk.image_id
      type     = local.workspaces[terraform.workspace].db_boot_disk.type
      size     = local.workspaces[terraform.workspace].db_boot_disk.size
    }
  }
  metadata = {
    user-data = file("${path.module}/cloud_config.yaml")
  }
  scheduling_policy {
    preemptible = local.workspaces[terraform.workspace].db_scheduling_policy.preemptible
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.k8s-private-zone-a.id
    ip_address = format("10.130.0.%d", count.index + 100)
    nat       = "true"
  }
}

resource "yandex_compute_instance" "db-slave" {

  name        = format("db-node-%03d", count.index + 1)
  # platform_id = var.yc_instances_control-plane
  hostname    = format("db-node-%03d", count.index + 1)
  description = "CP node for diplom demonstration"
  count       = local.workspaces[terraform.workspace].db_nodes_count +1


  resources {
    cores         = local.workspaces[terraform.workspace].db_resources.cores
    memory        = local.workspaces[terraform.workspace].db_resources.memory
    core_fraction = local.workspaces[terraform.workspace].db_resources.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = local.workspaces[terraform.workspace].db_boot_disk.image_id
      type     = local.workspaces[terraform.workspace].db_boot_disk.type
      size     = local.workspaces[terraform.workspace].db_boot_disk.size
    }
  }
  metadata = {
    user-data = file("${path.module}/cloud_config.yaml")
  }
  scheduling_policy {
    preemptible = local.workspaces[terraform.workspace].db_scheduling_policy.preemptible
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.k8s-private-zone-a.id
    ip_address = format("10.130.0.%d", count.index + 120)
    nat       = "true"
  }
}