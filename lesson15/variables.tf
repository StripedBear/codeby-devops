variable "auth_token" {
  description = "Yandex Cloud OAuth token"
  type        = string
}

variable "cloud_id" {
  description = "Yandex Cloud ID"
  type        = string
}

variable "folder_id" {
  description = "Yandex Folder ID"
  type        = string
}

variable "network_id" {
  description = "ID of the VPC network"
  type        = string
}

variable "zone" {
  description = "Default availability zone"
  type        = string
  default     = "ru-central1-a"
}

variable "public_key_path" {
  description = "Path to the SSH public key"
  type        = string
}

variable "private_key_path" {
  description = "Path to the SSH private key"
  type        = string
}