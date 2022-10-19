locals {
    workspaces = {
        stage = {
            folder_id =  file("../02.yc_folders/stage")
            K8s_cpn_count = 1
            K8s_wn_count = 2
            K8s_etcd_count = 1
            db_nodes_count = 1

            # control-plane
            cpn_resources = {
                cores         = "10"
                memory        = "10"
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
            # workers
            wn_resources ={
                cores         = "10"
                memory        = "10"
                core_fraction = "100"
            }
            wn_boot_disk = {
                image_id = "fd8f1tik9a7ap9ik2dg1"
                type     = "network-ssd"
                size     = "3"
            }
            wn_scheduling_policy = {
                preemptible = "true"
            }

            # etcd
            etcd_resources ={
                cores         = "10"
                memory        = "10"
                core_fraction = "100"
            }
            etcd_boot_disk = {
                image_id = "fd8f1tik9a7ap9ik2dg1"
                type     = "network-ssd"
                size     = "25"
            }
            etcd_scheduling_policy = {
                preemptible = "true"
            }

            # db
            db_resources = {
                cores         = "10"
                memory        = "10"
                core_fraction = "100"
            }
            db_boot_disk = {
                image_id = "fd8f1tik9a7ap9ik2dg1"
                type     = "network-ssd"
                size     = "30"
            }
            db_scheduling_policy = {
                preemptible = "true"
            }

        }
        prod = {
            folder_id =  file("../02.yc_folders/prod")
            K8s_cpn_count = 3
            K8s_wn_count = 4
            K8s_etcd_count = 2
            db_nodes_count = 2
            
            # control-plane
            cpn_resources = {
                cores         = "15"
                memory        = "15"
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
            # workers
            wn_resources = {
                cores         = "15"
                memory        = "15"
                core_fraction = "100"
            }
            wn_boot_disk = {
                image_id = "fd8f1tik9a7ap9ik2dg1"
                type     = "network-ssd"
                size     = "30"
            }
            wn_scheduling_policy = {
                preemptible = "false"
            }

            # etcd
            etcd_resources ={
                cores         = "15"
                memory        = "15"
                core_fraction = "100"
            }
            etcd_boot_disk = {
                image_id = "fd8f1tik9a7ap9ik2dg1"
                type     = "network-ssd"
                size     = "30"
            }
            etcd_scheduling_policy = {
                preemptible = "true"
            }
            
            #db
            db_resources = {
                cores         = "10"
                memory        = "10"
                core_fraction = "100"
            }
            db_boot_disk = {
                image_id = "fd8f1tik9a7ap9ik2dg1"
                type     = "network-ssd"
                size     = "50"
            }
            db_scheduling_policy = {
                preemptible = "true"
            }
        }
    }
}