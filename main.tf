#module "yc-vpc" {
#  source              = "git::https://git@github.com/terraform-yc-modules/terraform-yc-vpc.git?ref=master"
#  network_name        = "ambulance-network"
#  network_description = "ambulance-network created with module"
#  private_subnets     = [
#    {
#      name           = "subnet-1"
#      zone           = "ru-central1-a"
#      v4_cidr_blocks = ["10.10.0.0/24"]
#    },
#    {
#      name           = "subnet-2"
#      zone           = "ru-central1-b"
#      v4_cidr_blocks = ["10.11.0.0/24"]
#    },
#    {
#      name           = "subnet-3"
#      zone           = "ru-central1-c"
#      v4_cidr_blocks = ["10.12.0.0/24"]
#    }
#  ]
#}

module "container-registry-images-puller" {
  source = "git::https://git@github.com/alxrem/terraform-yandex-service-account?ref=master"
  name = "container-registry-images-puller"
  folder_id = local.folder_id
  roles = ["container-registry.images.puller"]
}

module "container-registry-images-pusher" {
  source = "git::https://git@github.com/alxrem/terraform-yandex-service-account?ref=master"
  name = "container-registry-images-pusher"
  folder_id = local.folder_id
  roles = ["container-registry.images.pusher"]
}

resource "yandex_container_registry" "ambulance-registry" {
  name = "ambulance-registry"
  folder_id = local.folder_id
}

#module "kube" {
#  source     = "git::https://git@github.com/terraform-yc-modules/terraform-yc-kubernetes.git?ref=master"
#  network_id = module.yc-vpc.vpc_id
#
#  master_locations  = [
#    {
#      zone      = lookup(module.yc-vpc.private_subnets["10.11.0.0/24"], "zone")
#      subnet_id = lookup(module.yc-vpc.private_subnets["10.11.0.0/24"], "subnet_id")
#    }
#  ]
#
#  master_maintenance_windows = [
#    {
#      day        = "monday"
#      start_time = "23:00"
#      duration   = "3h"
#    }
#  ]
#
#  node_groups = {
#    "ambulance-worker-nodes"  = {
#      description   = "Ambulance worker nodes group"
#      auto_scale    = {
#        min         = 3
#        max         = 7
#        initial     = 3
#      }
#      max_expansion   = 1
#      max_unavailable = 1
#    }
#  }
#}