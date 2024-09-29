module "data_subnet" {
  source = "./data_subnet"
  access_token  = var.auth_token
  cloud_identifier  = var.cloud_id
  folder_identifier = var.folder_id
  network_id    = var.network_id
}

locals {
  selected_subnet_id = lookup(module.data_subnet.subnets_details, var.zone, [])[0]
}

module "vm" {
  source = "./vm"
  auth_token = var.auth_token
  cloud_id = var.cloud_id
  folder_id = var.folder_id
  selected_subnet_id = local.selected_subnet_id
  zone = var.zone
  public_key_path = var.public_key_path
  private_key_path = var.private_key_path
}