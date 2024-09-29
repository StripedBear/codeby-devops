terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.70"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  token     = var.auth_token
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
}

# Variables for setup
variable "auth_token" {
  description = "Yandex Cloud OAuth token for authentication"
  type        = string
}

variable "cloud_id" {
  description = "Cloud ID for the Yandex.Cloud project"
  type        = string
}

variable "folder_id" {
  description = "Folder ID within Yandex.Cloud"
  type        = string
}

variable "selected_subnet_id" {
  description = "Subnet ID in which to create the VM"
  type        = string
}

variable "zone" {
  description = "Availability zone for VM creation"
  type        = string
}

variable "public_key_path" {
  description = "Path to the SSH public key for access"
  type        = string
}

variable "private_key_path" {
  description = "Path to the SSH private key for access"
  type        = string
}

# Resource for my instance
resource "yandex_compute_instance" "instance" {
  name        = "custom-vm-instance"
  platform_id = "standard-v1"
  zone        = var.zone

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd808e721rc1vt7jkd0o" # Ubuntu 20.04 LTS
    }
  }

  # Network interface with NAT
  network_interface {
    subnet_id = var.selected_subnet_id
    nat       = true
  }

  # Data for SSH
  metadata = {
    ssh-keys = "ubuntu:${file(var.public_key_path)}"
  }

  # Provisioners to uploading keys for SSH and setting up
  provisioner "file" {
    source      = var.private_key_path
    destination = "/home/ubuntu/id_rsa"
    connection {
      type        = "ssh"
      host        = self.network_interface[0].nat_ip_address
      user        = "ubuntu"
      private_key = file(var.private_key_path)
    }
  }

  provisioner "file" {
    source      = var.public_key_path
    destination = "/home/ubuntu/id_rsa.pub"
    connection {
      type        = "ssh"
      host        = self.network_interface[0].nat_ip_address
      user        = "ubuntu"
      private_key = file(var.private_key_path)
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod 600 /home/ubuntu/id_rsa",
      "ssh-keyscan -H ${self.network_interface[0].nat_ip_address} >> ~/.ssh/known_hosts",
    ]
    connection {
      type        = "ssh"
      host        = self.network_interface[0].nat_ip_address
      user        = "ubuntu"
      private_key = file(var.private_key_path)
    }
  }
}

# Output for VM`s external IP
output "vm_ip_address" {
  value = yandex_compute_instance.instance.network_interface[0].nat_ip_address
}
