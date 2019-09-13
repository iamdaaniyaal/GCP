// Configure the Google Cloud provider
provider "google" {
  credentials = "${file("${var.credentials}")}"
  project     = "${var.gcp_project}"
  region      = "${var.region}"
}






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
  region        = "${var.region}"
}

// VPC 1 INGRESS firewall configuration
resource "google_compute_firewall" "firewall1" {
  name      = "${var.vpc1_name}-ingress-firewall"
  network   = "${google_compute_network.vpc1.name}"
  direction = "INGRESS"

  allow {
    protocol = "${var.firewall_protocol1}"
  }



  allow {
    protocol = "tcp"
    ports    = ["80", "22", "3306"]


  }



  //Giving source ranges as this is a INGRESS Firewall Rule
  source_ranges = "${var.subnet1_source_ranges}"
}
// VPC 1  EGRESS firewall configuration
resource "google_compute_firewall" "firewall2" {
  name               = "${var.vpc1_name}-egress-firewall"
  network            = "${google_compute_network.vpc1.name}"
  direction          = "EGRESS"
  destination_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "${var.firewall_protocol1}"
  }



  allow {
    protocol = "tcp"
    ports    = ["80", "22", "3306"]
  }

  //Not giving source ranges as this is a EGRESS Firewall Rule
  //source_ranges = "${var.subnet1_source_ranges}"
}



//Compute instance in VPC 2
# resource "google_compute_instance" "compute" {
#   name         = "${var.compute_instance_name_in_vpc_2}"
#   machine_type = "n1-standard-1"
#   zone         = "us-central1-a"

#   boot_disk {
#     initialize_params {
#       image = "debian-cloud/debian-9"
#     }
#   }

#   // Local SSD disk
#   scratch_disk {
#   }

#   network_interface {
#     network    = "${google_compute_network.vpc2.self_link}"
#     subnetwork = "${google_compute_subnetwork.subnet2.self_link}"

#     access_config {
#       // Ephemeral IP
#     }
#   }

# }


resource "google_compute_address" "static" {
  name = "ipaddress"
}



resource "google_compute_instance" "default" {
  name         = "wp1"
  machine_type = "n1-standard-1"
  zone         = "us-central1-a"

  tags = ["foo", "bar"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  // Local SSD disk
  # scratch_disk {
  # }

  network_interface {
    network    = "${google_compute_network.vpc1.self_link}"
    subnetwork = "${google_compute_subnetwork.subnet1.self_link}"

    access_config {
      // Ephemeral IP

      nat_ip = "${google_compute_address.static.address}"
    }
  }

  provisioner "file" {
    content     = "${data.template_file.phpconfig.rendered}"
    destination = "/wp-config.php"

    connection {
      type     = "ssh"
      user     = "root"
      password = "root123"
      # host     = "${google_compute_instance.default.network_interface[0].access_config[0].nat_ip}"
      host = "${google_compute_address.static.address}"
    }
  }


  # provisioner "file" {
  #   source      = "script.sh"
  #   destination = "/tmp/script.sh"



  #   connection {
  #     type     = "ssh"
  #     user     = "test"
  #     password = "test123"
  #     host     = "${google_compute_address.static.address}"
  #   }
  # }

  # provisioner "remote-exec" { 
  #   inline = [
  #     "chmod +x /tmp/script.sh",
  #     "/tmp/script.sh args",
  #   ]
  # }

  # metadata = {
  #   foo = "bar"
  # }

  metadata_startup_script = "sudo  echo \"root:root123\" | chpasswd; sudo  mv /etc/ssh/sshd_config  /opt; sudo touch /etc/ssh/sshd_config; sudo echo -e \"Port 22\nHostKey /etc/ssh/ssh_host_rsa_key\nPermitRootLogin yes\nPubkeyAuthentication yes\nPasswordAuthentication yes\nUsePAM yes\" >  /etc/ssh/sshd_config; sudo systemctl restart sshd; sudo apt install git  -y; git clone https://github.com/iamdaaniyaal/GCP.git; cd GCP/Terraform; sudo chmod 777 script.sh; ./script.sh"

  # service_account {
  #   scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  # }
}



data "template_file" "phpconfig" {
  # template = "${file("conf.wp-config.php")}"

  template = templatefile("conf.wp-conf.php", { db_host = "${google_sql_database_instance.sql.private_ip_address}", db_name = "${google_sql_database.database.name}", db_user = "${google_sql_user.users.name}", db_pass = "${google_sql_user.users.password}" })

  # vars =
  #   db_port = "${google_sql_database_instance.master.port}"
  #   db_host = "${google_sql_database_instance.master.address}"
  #   db_user = "${var.username}"
  #   db_pass = "${var.password}"
  #   db_name = "${var.dbname}"

}


resource "google_compute_global_address" "private_ip_alloc" {
  name          = "private-ip-alloc"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = "${google_compute_network.vpc1.self_link}"
}

resource "google_service_networking_connection" "foobar" {
  network                 = "${google_compute_network.vpc1.self_link}"
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = ["${google_compute_global_address.private_ip_alloc.name}"]
}







resource "google_sql_database_instance" "sql" {
  name             = "sql-instance2121"
  database_version = "MYSQL_5_7"
  region           = "us-central1"




  depends_on = [
    "google_service_networking_connection.foobar"
  ]


  settings {
    # Second-generation instance tiers are based on the machine
    # type. See argument reference below.
    tier = "db-f1-micro"

    ip_configuration {
      ipv4_enabled    = true
      private_network = "${google_compute_network.vpc1.self_link}"
      authorized_networks {
        # value = "${google_compute_instance.default.network_interface[0].access_config[0].nat_ip}/32"
        value = "${google_compute_address.static.address}/32"
        name  = "allowedip"
      }
    }


    # depends_on = [
    #   "google_compute_instance.default",
    # ]
  }



}



resource "google_sql_database" "database" {
  name     = "wp-database"
  instance = "${google_sql_database_instance.sql.name}"


  # depends_on = [
  #   "google_sql_database_instance.sql",
  # ]
}



resource "google_sql_user" "users" {
  name     = "user123"
  instance = "${google_sql_database_instance.sql.name}"
  password = "12345"
  # host     = "${google_compute_instance.default.network_interface[0].access_config[0].nat_ip}"
  host = "${google_compute_address.static.address}"
}
