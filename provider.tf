terraform {
  required_version = ">=1.0.0"

  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "> 0.8"
    }
  }
  backend "s3" {
    endpoint = "storage.yandexcloud.net"
    region = "ru-central1"

    bucket = "ambulance-tf-state"
    key = "tf.state"

    skip_region_validation = true
    skip_credentials_validation = true

    dynamodb_endpoint = "https://docapi.serverless.yandexcloud.net/ru-central1/b1gm48epglvomnhepg5j/etnsh9nk24qmkmtdcksq"
    dynamodb_table = "ambulance-tf-state"
  }
}

locals {
  folder_id = "b1gk7spl5e7j0h0jldle"
  cloud_id = "b1gm48epglvomnhepg5j"
}

provider "yandex" {
  cloud_id = local.cloud_id
  folder_id = local.folder_id
}