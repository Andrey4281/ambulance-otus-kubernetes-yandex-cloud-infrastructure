module "kube" {
  source     = "./modules/kube"
  network_id = module.yc-vpc.vpc_id

  master_locations  = [
    {
      zone      = lookup(module.yc-vpc.private_subnets["10.11.0.0/24"], "zone")
      subnet_id = lookup(module.yc-vpc.private_subnets["10.11.0.0/24"], "subnet_id")
    }
  ]

  master_maintenance_windows = [
    {
      day        = "monday"
      start_time = "23:00"
      duration   = "3h"
    }
  ]

  node_groups = {
    "ambulance-worker-nodes"  = {
      description   = "Ambulance worker nodes group"
      auto_scale    = {
        min         = 3
        max         = 7
        initial     = 3
      }
      max_expansion   = 1
      max_unavailable = 1
    }
  }
}