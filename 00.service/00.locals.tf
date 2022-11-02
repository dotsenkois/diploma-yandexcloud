locals {
  ssh_user = "dotsenkois"
  ssh_pub_key = "~/.ssh/netology.pub"
  folder_id = "b1go4qtrnudtfjc3lns7"
  service-instance_resources = {
      cores         = "2"
      memory        = "4"
      core_fraction = "5"
  }
  service-instance_boot_disk = {
      image_id = "fd8f1tik9a7ap9ik2dg1"
      type     = "network-hdd"
      size     = "15"
  }
  service-instance_scheduling_policy = {
      preemptible = "false"
  }
}
