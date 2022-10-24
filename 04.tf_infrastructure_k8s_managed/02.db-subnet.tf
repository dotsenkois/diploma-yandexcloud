resource "yandex_vpc_subnet" "db-subnet" {
  v4_cidr_blocks = ["192.168.10.96/28"]
  zone           = "ru-central1-a"
  network_id =  yandex_vpc_network.k8s-network.id
  route_table_id = yandex_vpc_route_table.lab-rt-a.id
}
