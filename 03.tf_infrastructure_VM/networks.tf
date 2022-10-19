resource "yandex_vpc_network" "k8s-network" {
  name = "k8s-network"
}

resource "yandex_vpc_subnet" "k8s-subnet-a" {
  name           = "k8s-subnet-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.k8s-network.id
  v4_cidr_blocks = ["10.130.0.0/24"]
}

resource "yandex_vpc_subnet" "K8s-subnet-b" {
  name           = "K8s-subnet-b"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.k8s-network.id
  v4_cidr_blocks = ["10.131.0.0/24"]
}
# resource "yandex_vpc_subnet" "K8s-subnet-c" {
#   name           = "K8s-subnet-c"
#   zone           = "ru-central1-c"
#   network_id     = yandex_vpc_network.K8s-network.id
#   v4_cidr_blocks = ["10.132.0.0/24"]
# }