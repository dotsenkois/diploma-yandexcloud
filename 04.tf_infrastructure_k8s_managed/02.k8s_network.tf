resource "yandex_vpc_network" "k8s-network" {
  name = "k8s-network"
}

resource "yandex_vpc_subnet" "db-snet" {
  v4_cidr_blocks = ["192.168.20.0/24"]
  zone           = "ru-central1-a"
  network_id =  yandex_vpc_network.k8s-network.id
}

resource "yandex_vpc_subnet" "nat-snet" {
  v4_cidr_blocks = ["192.168.40.0/24"]
  zone           = "ru-central1-a"
  network_id =  yandex_vpc_network.k8s-network.id
}




