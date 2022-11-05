locals {
    workspaces = {
        dotsenkois-stage = {
            folder_id =  file("../02.yc_folders/dotsenkois-stage")
            scale_policy = {
                auto_scale ={
                    min     = 1
                    max     = 4
                    initial = 1
                }
            }
            #db
            db = {
            master_count = 1
            slave_count = 0

            resources = {
                cores         = "2"
                memory        = "4"
                core_fraction = "5"
            }
            boot_disk = {
                image_id = "fd8f1tik9a7ap9ik2dg1"
                type     = "network-hdd"
                size     = "10"
            }
            scheduling_policy = {
                preemptible = "false"
            }
            }

            # service-instance

            service-instance = {
            count = 1

            resources = {
                cores         = "2"
                memory        = "4"
                core_fraction = "5"
            }
            boot_disk = {
                image_id = "fd8f1tik9a7ap9ik2dg1"
                type     = "network-hdd"
                size     = "20"
            }
            scheduling_policy = {
                preemptible = "false"
            }
            }
            #CI/CD

            # jenkins
            jenkins = {
            count = 1
        
            resources = {
                cores         = "4"
                memory        = "4"
                core_fraction = "20"
            }
            boot_disk = {
                image_id = "fd8n2l6igots3v1qfptm"
                type     = "network-ssd"
                size     = "15"
            }
            scheduling_policy = {
                preemptible = "false"
            }
            }
            
            # teamcity
            teamcity = {
            count = 1
            resources = {
                cores         = "2"
                memory        = "4"
                core_fraction = "5"
            }
            boot_disk = {
                image_id = "fd8f1tik9a7ap9ik2dg1"
                type     = "network-hdd"
                size     = "10"
            }
            scheduling_policy = {
                preemptible = "false"
            }
            }

            # gitlab
            gitlab = {
            count = 1
            resources = {
                cores         = "2"
                memory        = "4"
                core_fraction = "5"
            }
            boot_disk = {
                image_id = "fd89dsd1oshk57psq3h9"
                type     = "network-hdd"
                size     = "10"
            }
            scheduling_policy = {
                preemptible = "false"
            }
            }





        }


        dotsenkois-prod = {
            folder_id =  file("../02.yc_folders/dotsenkois-prod")
            scale_policy = {
                auto_scale ={
                    min     = 3
                    max     = 5
                    initial = 3
                }
                }
           #db
            db_master_count = 2
            db_slave_count = 4

            db_resources = {
                cores         = "4"
                memory        = "4"
                core_fraction = "100"
            }
            db_boot_disk = {
                image_id = "fd8f1tik9a7ap9ik2dg1"
                type     = "network-hdd"
                size     = "50"
            }
            db_scheduling_policy = {
                preemptible = "true"
            } 

                        # service-instance
            service-instance_count = 1

            service-instance_resources = {
                cores         = "2"
                memory        = "4"
                core_fraction = "20"
            }
            service-instance_boot_disk = {
                image_id = "fd8f1tik9a7ap9ik2dg1"
                type     = "network-hdd"
                size     = "20"
            }
            service-instance_scheduling_policy = {
                preemptible = "true"
            }

            }
    }
    }