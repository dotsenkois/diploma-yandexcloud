resource "yandex_vpc_subnet" "nat-subnet" {
  v4_cidr_blocks = ["192.168.10.112/28"]
  zone           = "ru-central1-a"
  network_id =  yandex_vpc_network.k8s-network.id
}
