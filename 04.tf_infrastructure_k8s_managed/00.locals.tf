locals {
    workspaces = {
        stage = {
            folder_id =  file("../02.yc_folders/stage")
            scale_policy = {
                auto_scale ={
                    min     = 3
                    max     = 6
                    initial = 3
                }
                }
            #db
            db_nodes_count = 1

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

        prod = {
            folder_id =  file("../02.yc_folders/prod")
            scale_policy = {
                auto_scale ={
                    min     = 5
                    max     = 10
                    initial = 5
                }
                }
            }
            #db
            db_nodes_count = 2


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