terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

locals {
  folder_id = "b1gk7spl5e7j0h0jldle"
  cloud_id = "b1gm48epglvomnhepg5j"
}

provider "yandex" {
  zone = "ru-central1-b"
  cloud_id = local.cloud_id
  folder_id = local.folder_id
  service_account_key_file = "authorized_key.json"
}