module "yc-vpc" {
  source              = "git::https://git@github.com/terraform-yc-modules/terraform-yc-vpc.git?ref=master"
  network_name        = "ambulance-network"
  network_description = "ambulance-network created with module"
  private_subnets     = [
    {
      name           = "subnet-1"
      zone           = "ru-central1-a"
      v4_cidr_blocks = ["10.10.0.0/24"]
    },
    {
      name           = "subnet-2"
      zone           = "ru-central1-b"
      v4_cidr_blocks = ["10.11.0.0/24"]
    },
    {
      name           = "subnet-3"
      zone           = "ru-central1-c"
      v4_cidr_blocks = ["10.12.0.0/24"]
    }
  ]
}

variable "TF_VAR_ADMIN_DATABASE_PASSWORD" {
  default = ""
}
module "ambulance-postgresql" {
  source      = "git::github.com/terraform-yc-modules/terraform-yc-postgresql?ref=master"
  network_id  = module.yc-vpc.vpc_id
  name        = "ambulance-postgresql"

  hosts_definition = [
    {
      zone             = lookup(module.yc-vpc.private_subnets["10.11.0.0/24"], "zone")
      assign_public_ip = false
      subnet_id        = lookup(module.yc-vpc.private_subnets["10.11.0.0/24"], "subnet_id")
    }
  ]

  postgresql_config = {
    max_connections = 100
  }

  databases = [
    {
      name       = "appeal"
      owner      = local.database_admin_name
      lc_collate = "ru_RU.UTF-8"
      lc_type    = "ru_RU.UTF-8"
      extensions = ["uuid-ossp", "xml2"]
    },
    {
      name       = "doctor"
      owner      = local.database_admin_name
      lc_collate = "ru_RU.UTF-8"
      lc_type    = "ru_RU.UTF-8"
      extensions = ["uuid-ossp", "xml2"]
    },
    {
      name       = "nurse"
      owner      = local.database_admin_name
      lc_collate = "ru_RU.UTF-8"
      lc_type    = "ru_RU.UTF-8"
      extensions = ["uuid-ossp", "xml2"]
    }
  ]

  owners = [
    {
      name       = local.database_admin_name
      password = "${var.TF_VAR_ADMIN_DATABASE_PASSWORD}"
      conn_limit = 15
    }
  ]

  users = [
    {
      name        = "guest"
      conn_limit  = 30
      permissions = ["hexlet"]
      settings = {
        pool_mode                   = "transaction"
        prepared_statements_pooling = true
      }
    }
  ]
}

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

module "kube" {
  source     = "git::https://git@github.com/terraform-yc-modules/terraform-yc-kubernetes.git?ref=master"
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