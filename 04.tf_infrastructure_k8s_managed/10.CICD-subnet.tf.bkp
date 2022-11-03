resource "yandex_vpc_subnet" "CICD-subnet" {
  name = "CICD-subnet"
  v4_cidr_blocks = ["192.168.10.144/28"]
  zone           = "ru-central1-a"
  network_id =  yandex_vpc_network.k8s-network.id
  route_table_id = yandex_vpc_route_table.lab-rt-a.id
}
