resource "google_compute_network" "vpc-network" {
  name                    = "vpc-ict-terraform"
  auto_create_subnetworks = false
  mtu                     = 1460
}

resource "google_compute_subnetwork" "vpc-subnet" {
  name          = "terraform-subnetwork"
  ip_cidr_range = "10.10.0.0/16"
  network       = google_compute_network.vpc-network.id
}

resource "google_compute_firewall" "default" {
  name    = "firewall-terraform"
  network = google_compute_network.vpc-network.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80", "8080", "1000-2000", "22"]
  }
  direction = "INGRESS"
  source_ranges = ["0.0.0.0/0"]
  target_tags = ["web"]
}


resource "google_compute_address" "static" {
  name = "ip-for-instance-terraform"
  network_tier =  "PREMIUM"
}

resource "google_compute_instance" "default" {
  name         = "instance-terraform-ikhsan-3"
  machine_type = "e2-medium"
  tags = ["web"]
  boot_disk {
    initialize_params {
      image = "projects/ubuntu-os-cloud/global/images/ubuntu-2204-jammy-v20230630"
      size = "50"
      type = "pd-balanced"
    }
  }
  network_interface {
    subnetwork = google_compute_subnetwork.vpc-subnet.id

    access_config {
      nat_ip = google_compute_address.static.address
    }
  }
  metadata_startup_script = "${file("./startup-script.sh")}"
}
