resource "yandex_vpc_network" "k8s-network" {
  name = "k8s-network"
}

resource "yandex_vpc_subnet" "db-snet" {
  v4_cidr_blocks = ["192.168.20.0/24"]
  zone           = "ru-central1-a"
  network_id =  yandex_vpc_network.k8s-network.id
  route_table_id = yandex_vpc_route_table.lab-rt-a.id
}

resource "yandex_vpc_subnet" "nat-snet" {
  v4_cidr_blocks = ["192.168.40.0/24"]
  zone           = "ru-central1-a"
  network_id =  yandex_vpc_network.k8s-network.id
}

resource "yandex_vpc_subnet" "k8s-private-zone-a" {
  v4_cidr_blocks = ["192.168.10.0/24"]
  zone           = "ru-central1-a"
  network_id =  yandex_vpc_network.k8s-network.id
}

resource "yandex_vpc_subnet" "k8s-private-zone-b" {
  v4_cidr_blocks = ["192.168.11.0/24"]
  zone           = "ru-central1-b"
  network_id =  yandex_vpc_network.k8s-network.id
}

resource "yandex_vpc_subnet" "k8s-private-zone-c" {
  v4_cidr_blocks = ["192.168.12.0/24"]
  zone           = "ru-central1-c"
  network_id =  yandex_vpc_network.k8s-network.id
}


