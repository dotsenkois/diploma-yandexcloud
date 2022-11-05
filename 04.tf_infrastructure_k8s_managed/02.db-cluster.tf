
resource "yandex_compute_instance" "db-master" {

  count       = local.workspaces[terraform.workspace].db.master_count
  name        = format("db-master-%03d", count.index +1)
  # platform_id = var.yc_instances_control-plane
  hostname    = format("db-master-%03d", count.index +1)
  description = "CP node for diplom demonstration"
  allow_stopping_for_update = true
  


  resources {
    cores         = local.workspaces[terraform.workspace].db.resources.cores
    memory        = local.workspaces[terraform.workspace].db.resources.memory
    core_fraction = local.workspaces[terraform.workspace].db.resources.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = local.workspaces[terraform.workspace].db.boot_disk.image_id
      type     = local.workspaces[terraform.workspace].db.boot_disk.type
      size     = local.workspaces[terraform.workspace].db.boot_disk.size
    }
  }
  metadata = {
    user-data = file("${path.module}/02.db-cluster-cloud_config.yaml")
  }
  scheduling_policy {
    preemptible = local.workspaces[terraform.workspace].db.scheduling_policy.preemptible
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.db-subnet.id
    ip_address = "192.168.10.100"
    # ip_address = format("192.168.10.%d", count.index + 99)
    nat       = "true"
  }
}

resource "yandex_compute_instance" "db-slave" {

  count       = local.workspaces[terraform.workspace].db.slave_count
  name        = format("db-slave-%03d", count.index +1 )
  # platform_id = var.yc_instances_control-plane
  hostname    = format("db-slave-%03d", count.index +1 )
  description = "CP node for diplom demonstration"



  resources {
    cores         = local.workspaces[terraform.workspace].db.resources.cores
    memory        = local.workspaces[terraform.workspace].db.resources.memory
    core_fraction = local.workspaces[terraform.workspace].db.resources.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = local.workspaces[terraform.workspace].db.boot_disk.image_id
      type     = local.workspaces[terraform.workspace].db.boot_disk.type
      size     = local.workspaces[terraform.workspace].db.boot_disk.size
    }
  }
  metadata = {
    user-data = file("${path.module}/02.db-cluster-cloud_config.yaml")
  }
  scheduling_policy {
    preemptible = local.workspaces[terraform.workspace].db.scheduling_policy.preemptible
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.db-subnet.id
    ip_address = format("192.168.10.%d", count.index + 105)
    nat       = "true"
  }
}