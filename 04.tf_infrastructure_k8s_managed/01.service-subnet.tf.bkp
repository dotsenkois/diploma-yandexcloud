resource "yandex_vpc_subnet" "service-subnet" {
  name = "service-subnet"
  v4_cidr_blocks = ["192.168.10.128/28"]
  zone           = "ru-central1-a"
  network_id =  yandex_vpc_network.k8s-network.id
}
