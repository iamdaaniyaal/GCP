// Configure the Google Cloud provider
provider "google" {
 credentials = "${file("${var.credentials}")}"
 project     = "${var.gcp_project}" 
 region      = "${var.region}"
}

// Create VPC 1
resource "google_compute_network" "vpc1" {
 name                    = "${var.vpc1_name}-vpc"
 auto_create_subnetworks = "false"
}

// Create VPC1 Subnet
resource "google_compute_subnetwork" "subnet1" {
 name          = "${var.vpc1_name}-subnet"
 ip_cidr_range = "${var.subnet1_cidr}"
 network       = "${var.vpc1_name}-vpc"
 depends_on    = ["google_compute_network.vpc1"]
 region      = "${var.region}"
}

// VPC 1 firewall configuration
resource "google_compute_firewall" "firewall1" {
  name    = "${var.vpc1_name}-firewall"
  network = "${google_compute_network.vpc1.name}"

  allow {
    protocol = "${var.firewall_protocol1}"
  }

   

  allow {
    protocol = "tcp"
    ports    = "${var.firewall_ports}"
  }

  source_ranges = ["0.0.0.0/0"]
}

// Create VPC 2
resource "google_compute_network" "vpc2" {
 name                    = "${var.vpc2_name}-vpc"
 auto_create_subnetworks = "false"
}

// Create VPC 2 Subnet
resource "google_compute_subnetwork" "subnet2" {
 name          = "${var.vpc2_name}-subnet"
 ip_cidr_range = "${var.subnet2_cidr}"
 network       = "${var.vpc2_name}-vpc"
 depends_on    = ["google_compute_network.vpc2"]
 region      = "${var.region}"
}

// VPC 1 firewall configuration
resource "google_compute_firewall" "firewall2" {
  name    = "${var.vpc2_name}-firewall"
  network = "${google_compute_network.vpc2.name}"

  allow {
    protocol = "${var.firewall_protocol1}"
  }

  

  allow {
    protocol = "tcp"
    ports    = "${var.firewall_ports}"
  }

  source_ranges = ["0.0.0.0/0"]
}



//VPN Gateway 1
resource "google_compute_vpn_gateway" "gateway1" {
  name    = "${var.vpn_gateway1}"
  network = "${google_compute_network.vpc1.self_link}"
}

//VPN Gateway 2
resource "google_compute_vpn_gateway" "gateway2" {
  name    = "${var.vpn_gateway2}"
  network = "${google_compute_network.vpc2.self_link}"
}

resource "google_compute_global_address" "default" {
  name = "global-appserver-ip"
}




resource "google_compute_address" "ip_address" {
  name = "my-address"
}


