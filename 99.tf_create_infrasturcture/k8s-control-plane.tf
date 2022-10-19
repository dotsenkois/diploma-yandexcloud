resource "yandex_compute_instance" "control_plane" {

  name        = format("k8s-control-plane-node-%03d", count.index + 1)
  # platform_id = var.yc_instances_control-plane
  hostname    = format("k8s-control-plane-node-%03d", count.index + 1)
  description = "CP node for diplom demonstration"
  count       = local.workspaces[terraform.workspace].K8s_cpn_count
  allow_stopping_for_update = true


  resources {
    cores         = local.workspaces[terraform.workspace].cpn_resources.cores
    memory        = local.workspaces[terraform.workspace].cpn_resources.memory
    core_fraction = local.workspaces[terraform.workspace].cpn_resources.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = local.workspaces[terraform.workspace].cpn_boot_disk.image_id
      type     = local.workspaces[terraform.workspace].cpn_boot_disk.type
      size     = local.workspaces[terraform.workspace].cpn_boot_disk.size
    }
  }
  metadata = {
    ssh-keys = "dotsenkois:${file("~/.ssh/id_rsa.pub")}"
  }
  scheduling_policy {
    preemptible = local.workspaces[terraform.workspace].cpn_scheduling_policy.preemptible
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.k8s-subnet-a.id
    ip_address = format("10.130.0.%d", count.index + 20)
    nat       = "true"
  }
}




# resource "yandex_compute_instance" "control_plane" {
#   for_each    = var.yc_instances_control-plane
#   name        = each.key
#   hostname    = each.key
#   platform_id = var.yc_platform_id
#   zone        = var.yc_zone

#   resources {
#     core_fraction = var.control-plane_resources.core_fraction
#     cores         = var.control-plane_resources.cores
#     memory        = var.control-plane_resources.memory
#   }

#   boot_disk {
#     initialize_params {
#       image_id = var.yc_image_id
#       size     = var.control-plane_resources.boot_disk_size
#     }
#   }

#   network_interface {
#     subnet_id  = yandex_vpc_subnet.k8s-subnet-1.id
#     ip_address = each.value
#     nat        = "true"
#   }

#   metadata = {
#     user-data = file("${path.module}/cloud_config.yaml")
#     # ssh-keys = "dotsenkois:${file("/home/dotsenkois/.ssh/id_rsa.pub")}"
#   }

#   scheduling_policy {
#     preemptible = true
#   }
# }
