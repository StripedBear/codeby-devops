terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.70"
    }
  }
}

provider "yandex" {
  token     = var.access_token
  cloud_id  = var.cloud_identifier
  folder_id = var.folder_identifier
}

# Variables for authentication and VPC details
variable "access_token" {
  description = "OAuth token for Yandex.Cloud authentication"
  type        = string
}

variable "cloud_identifier" {
  description = "Identifier of the Yandex.Cloud"
  type        = string
}

variable "folder_identifier" {
  description = "Identifier of the folder in Yandex.Cloud"
  type        = string
}

variable "network_id" {
  description = "Identifier of the VPC network"
  type        = string
}

data "yandex_vpc_network" "vpc_data" {
  network_id = var.network_id
}

# all subnets associated with the VPC network
data "yandex_vpc_subnet" "vpc_subnets" {
  for_each = toset(data.yandex_vpc_network.vpc_data.subnet_ids)
  subnet_id = each.key
}

# Mapping of subnets for their zones
locals {
  subnets_mapping = { for subnet in data.yandex_vpc_subnet.vpc_subnets : subnet.zone => subnet.id }
}

output "subnets_details" {
  value = local.subnets_mapping
}
