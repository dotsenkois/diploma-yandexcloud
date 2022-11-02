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
            db_master_count = 1
            db_slave_count = 0

            db_resources = {
                cores         = "2"
                memory        = "4"
                core_fraction = "5"
            }
            db_boot_disk = {
                image_id = "fd8f1tik9a7ap9ik2dg1"
                type     = "network-hdd"
                size     = "20"
            }
            db_scheduling_policy = {
                preemptible = "true"
            }

            #CI/CD

            # jenkins
            jenkins_count = 1
        
            jenkins_resources = {
                cores         = "2"
                memory        = "4"
                core_fraction = "5"
            }
            jenkins_boot_disk = {
                image_id = "fd8f1tik9a7ap9ik2dg1"
                type     = "network-hdd"
                size     = "20"
            }
            jenkins_scheduling_policy = {
                preemptible = "true"
            }

            # gitlab_runner
            gitlab_runner_count = 1

            gitlab_runner_resources = {
                cores         = "2"
                memory        = "4"
                core_fraction = "5"
            }
            gitlab_runner_boot_disk = {
                image_id = "fd8f1tik9a7ap9ik2dg1"
                type     = "network-hdd"
                size     = "20"
            }
            gitlab_runner_scheduling_policy = {
                preemptible = "true"
            }

            # service-instance
            service-instance_count = 1

            service-instance_resources = {
                cores         = "2"
                memory        = "4"
                core_fraction = "5"
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