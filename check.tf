resource "google_compute_instance" "database" {
  name         = "database"
  machine_type = "n1-standard-2"
  zone         = "${var.gcp_zone}"
  tags = ["db"]
  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1804-lts"
    }
  }
  // Local SSD disk
  scratch_disk {}
  network_interface {
    network = "${var.name}-vpc"
    subnetwork = "${var.name}-subnet"
    access_config {
      // Ephemeral IP
    }
  }
}
