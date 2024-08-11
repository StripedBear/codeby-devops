resource "google_compute_instance" "public_vm" {
  name         = "public-vm"
  machine_type = "e2-micro"
  tags         = ["public-vm"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network            = google_compute_network.custom_vpc.name
    subnetwork         = google_compute_subnetwork.public_subnet.name
    access_config {}  # Это добавляет публичный IP-адрес
  }

  metadata = {
    ssh-keys = "potapovbear:${file("~/.ssh/id_rsa.pub")}"
  }

  # Установка Nginx
  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      user     = "potapovbear"  
      private_key = file("~/.ssh/id_rsa")  
      host     = self.network_interface[0].access_config[0].nat_ip  # Публичный IP-адрес
    }

    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y nginx",
      "sudo systemctl start nginx",
      "sudo systemctl enable nginx"
    ]
  }
}

resource "google_compute_instance" "private_vm" {
  name         = "private-vm"
  machine_type = "e2-micro"
  tags         = ["private-vm"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network    = google_compute_network.custom_vpc.name
    subnetwork = google_compute_subnetwork.private_subnet.name
  }

  # Установка Nginx
  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      user     = "potapovbear"
      private_key = file("~/.ssh/id_rsa")  
      host     = self.network_interface[0].network_ip  # Внутренний IP-адрес
    }

    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y nginx",
      "sudo systemctl start nginx",
      "sudo systemctl enable nginx"
    ]
  }
}

output "public_vm_ip" {
  value = google_compute_instance.public_vm.network_interface[0].access_config[0].nat_ip
}

output "private_vm_ip" {
  value = google_compute_instance.private_vm.network_interface[0].network_ip
}

resource "google_compute_instance" "manual_vm" {
  name         = "manual-inst"  
  machine_type = "e2-micro"  
  zone         = "asia-south1-a"

  boot_disk {
    initialize_params {
      image = "debian-12-bookworm-v20240709" 
    }
  }

  network_interface {
    network = google_compute_network.custom_vpc.self_link
    subnetwork = google_compute_subnetwork.public_subnet.self_link

    access_config {
          }
  }

  tags = ["manual-vm"]
}
