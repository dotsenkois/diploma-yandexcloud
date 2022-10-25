resource "yandex_vpc_subnet" "k8s-private-zone-a" {
  name = "k8s-private-zone-a"
  v4_cidr_blocks = ["192.168.10.0/27"]
  zone           = "ru-central1-a"
  network_id =  yandex_vpc_network.k8s-network.id
  route_table_id = yandex_vpc_route_table.lab-rt-a.id
}

resource "yandex_vpc_subnet" "k8s-private-zone-b" {
  name = "k8s-private-zone-b"
  v4_cidr_blocks = ["192.168.10.32/27"]
  zone           = "ru-central1-b"
  network_id =  yandex_vpc_network.k8s-network.id
  route_table_id = yandex_vpc_route_table.lab-rt-a.id
}

resource "yandex_vpc_subnet" "k8s-private-zone-c" {
  name = "k8s-private-zone-c"
  v4_cidr_blocks = ["192.168.10.64/27"]
  zone           = "ru-central1-c"
  network_id =  yandex_vpc_network.k8s-network.id
  route_table_id = yandex_vpc_route_table.lab-rt-a.id
}
