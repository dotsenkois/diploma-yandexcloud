locals {
  folder_id = "b1gngst23dqhbmmjvob0"
  service-instance_resources = {
      cores         = "4"
      memory        = "4"
      core_fraction = "100"
  }
  service-instance_boot_disk = {
      image_id = "fd8f1tik9a7ap9ik2dg1"
      type     = "network-ssd"
      size     = "20"
  }
  service-instance_scheduling_policy = {
      preemptible = "true"
  }
}
