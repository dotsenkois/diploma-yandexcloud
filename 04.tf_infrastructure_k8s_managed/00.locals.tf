locals {
    workspaces = {
        stage = {
            folder_id =  file("../02.yc_folders/stage")
            K8s_cpn_count = 1
            K8s_wn_count = 2
            cpn_resources = {
                cores         = "10"
                memory        = "6"
                core_fraction = "100"
            }
            cpn_boot_disk = {
                image_id = "fd8f1tik9a7ap9ik2dg1"
                type     = "network-ssd"
                size     = "20"
            }
            cpn_scheduling_policy = {
                preemptible = "true"
            }

            wn_resources ={
                cores         = "10"
                memory        = "6"
                core_fraction = "100"
            }
            wn_boot_disk = {
                image_id = "fd8f1tik9a7ap9ik2dg1"
                type     = "network-ssd"
                size     = "40"
            }
            wn_scheduling_policy = {
                preemptible = "true"
            }
        }
        prod = {
            folder_id =  file("../02.yc_folders/prod")
            K8s_cpn_count = 3
            K8s_wn_count = 4
            cpn_resources = {
                cores         = "20"
                memory        = "6"
                core_fraction = "100"
            }
            cpn_boot_disk = {
                image_id = "fd8f1tik9a7ap9ik2dg1"
                type     = "network-ssd"
                size     = "30"
            }
            cpn_scheduling_policy = {
                preemptible = "false"
            }

            wn_resources = {
                cores         = "20"
                memory        = "10"
                core_fraction = "100"
            }
            wn_boot_disk = {
                image_id = "fd8f1tik9a7ap9ik2dg1"
                type     = "network-ssd"
                size     = "50"
            }
            wn_scheduling_policy = {
                preemptible = "false"
            }
        }
    }
}