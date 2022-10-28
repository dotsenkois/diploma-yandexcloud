locals {
  folder_id =  file("../02.yc_folders/service")
  ansible-service-instance_resources = {
      cores         = "2"
      memory        = "4"
      core_fraction = "5"
  }
  ansible-service-instance_boot_disk = {
      image_id = "fd8f1tik9a7ap9ik2dg1"
      type     = "network-hdd"
      size     = "20"
  }
  ansible-service-instance_scheduling_policy = {
      preemptible = "true"
  }
}
