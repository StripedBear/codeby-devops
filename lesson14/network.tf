provider "google" {
  credentials = file("mygcp-creds.json")
  project = "prod-432204"
  region  = "asia-south1"
  zone = "asia-south1-a"
}

resource "google_compute_network" "custom_vpc" {
  name                    = "custom-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "public_subnet" {
  name          = "public-subnet"
  ip_cidr_range = "10.0.1.0/24"
  network       = google_compute_network.custom_vpc.id
  region        = "asia-south1"
}

resource "google_compute_subnetwork" "private_subnet" {
  name          = "private-subnet"
  ip_cidr_range = "10.0.2.0/24"
  network       = google_compute_network.custom_vpc.id
  region        = "asia-south1"
}

resource "google_compute_firewall" "allow-ssh-http-https" {
  name    = "allow-ssh-http-https"
  network = google_compute_network.custom_vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["public-vm"]
}

resource "google_compute_firewall" "allow-ssh-8080" {
  name    = "allow-ssh-8080"
  network = google_compute_network.custom_vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22", "8080"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["private-vm"]
}
