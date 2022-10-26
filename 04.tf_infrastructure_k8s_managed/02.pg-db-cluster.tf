
resource "yandex_mdb_postgresql_cluster" "just-cluster" {
  name                = "just-cluster"
  environment         = "PRESTABLE"
  network_id          =  yandex_vpc_network.k8s-network.id
#   security_group_ids  = [ "<список групп безопасности>" ]
  deletion_protection = false
  

  config {
    version = "14"
    resources {
      resource_preset_id = "b1.nano"
      disk_type_id       = "network-hdd"
      disk_size          = 20
    }
    pooler_config {
      pool_discard = false
      pooling_mode = "STATEMENT"
    }
  }

  host {
    zone      = yandex_vpc_subnet.db-subnet.zone
    name      = "main-db"
    subnet_id = yandex_vpc_subnet.db-subnet.id
  }

  maintenance_window {
    type = "WEEKLY"
    day  = "SUN"
    hour = 12
  }
}

resource "yandex_mdb_postgresql_database" "netology" {
  cluster_id = yandex_mdb_postgresql_cluster.just-cluster.id
  name       = "netology"
  owner      = "dotsenkois"
  depends_on = [
    yandex_mdb_postgresql_user.admin
  ]
}

resource "yandex_mdb_postgresql_user" "admin" {
  cluster_id = yandex_mdb_postgresql_cluster.just-cluster.id
  name       = "dotsenkois"
  password   = "korgAX3G"
}

