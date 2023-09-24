terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "> 0.8"
    }
    random = {
      source  = "hashicorp/random"
      version = "> 3.3"
    }
    time = {
      source  = "hashicorp/time"
      version = "> 0.9"
    }
  }
  backend "s3" {
    endpoint = "storage.yandexcloud.net"
    region = "ru-central1"
    bucket = "terraform-ambulance"
    key = "ambulance.tfstate"

    skip_region_validation = true
    skip_credentials_validation = true
  }
  required_version = ">= 1.0.0"
}

locals {
  folder_id = "b1gk7spl5e7j0h0jldle"
  cloud_id = "b1gm48epglvomnhepg5j"
  database_admin_name = "andrey4281"
}

provider "yandex" {
  cloud_id = local.cloud_id
  folder_id = local.folder_id
}