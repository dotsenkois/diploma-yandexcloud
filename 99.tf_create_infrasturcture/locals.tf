locals {
    workspaces = {
        stage = {
            folder_id =  file("../yc_folders/stage")
            K8s_cpn_count = 1
            K8s_wn_count = 2
            cpn_resources = {
                cores         = "2"
                memory        = "4"
                core_fraction = "20"
            }
            cpn_boot_disk = {
                image_id = "fd8f1tik9a7ap9ik2dg1"
                type     = "network-hdd"
                size     = "15"
            }
            cpn_scheduling_policy = {
                preemptible = "true"
            }

            wn_resources ={
                cores         = "2"
                memory        = "6"
                core_fraction = "20"
            }
            wn_boot_disk = {
                image_id = "fd8f1tik9a7ap9ik2dg1"
                type     = "network-hdd"
                size     = "25"
            }
            wn_scheduling_policy = {
                preemptible = "true"
            }
        }
        prod = {
            folder_id =  file("../yc_folders/prod")
            K8s_cpn_count = 3
            K8s_wn_count = 4
            cpn_resources = {
                cores         = "4"
                memory        = "6"
                core_fraction = "50"
            }
            cpn_boot_disk = {
                image_id = "fd8f1tik9a7ap9ik2dg1"
                type     = "network-hdd"
                size     = "30"
            }
            cpn_scheduling_policy = {
                preemptible = "false"
            }

            wn_resources = {
                cores         = "4"
                memory        = "10"
                core_fraction = "50"
            }
            wn_boot_disk = {
                image_id = "fd8f1tik9a7ap9ik2dg1"
                type     = "network-hdd"
                size     = "50"
            }
            wn_scheduling_policy = {
                preemptible = "false"
            }

        }
    }
}


#   number_of_K8s_control_plane_nodes = {
#     stage = 1
#     prod  = 3
#   }

#   number_of_K8s_worker_nodes = {
#     stage = 2
#     prod  = 4
#   }

#   resources_cores_of_K8s_control_plane_nodes = {
#     stage = 2
#     prod  = 3
#   }

#   number_of_K8s_worker_nodes = {
#     stage = 2
#     prod  = 4
#   }

