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
  required_version = ">= 1.0.0"
}

locals {
  folder_id = "b1gk7spl5e7j0h0jldle"
  cloud_id = "b1gm48epglvomnhepg5j"
}

provider "yandex" {
  cloud_id = local.cloud_id
  folder_id = local.folder_id
}