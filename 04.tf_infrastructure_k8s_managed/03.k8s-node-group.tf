resource "yandex_kubernetes_node_group" "k8s-netology-node-group" {
    cluster_id = yandex_kubernetes_cluster.k8s-netology.id
    version = "1.21"
    
    allocation_policy{
        location{
            zone = yandex_vpc_subnet.k8s-private-zone-a.zone
        }
    }
  
    instance_template {
        boot_disk {
            type = "network-hdd"
            size = 30
        }
        platform_id = "standard-v2"
    network_interface {
      subnet_ids = [yandex_vpc_subnet.k8s-private-zone-a.id]
      nat = false
    }
}
  scale_policy {
    auto_scale {
      min     = local.workspaces[terraform.workspace].scale_policy.auto_scale.min
      max     = local.workspaces[terraform.workspace].scale_policy.auto_scale.max
      initial = local.workspaces[terraform.workspace].scale_policy.auto_scale.initial
    }
  }
  # scheduling_policy {
  #     preemptible = true
  #   }
}
