locals {
  folder_id = "b1gus775j3oh0btnf9ue"
  service-instance_resources = {
      cores         = "4"
      memory        = "4"
      core_fraction = "20"
  }
  service-instance_boot_disk = {
      image_id = "fd8f1tik9a7ap9ik2dg1"
      type     = "network-ssd"
      size     = "30"
  }
  service-instance_scheduling_policy = {
      preemptible = "false"
  }
}
