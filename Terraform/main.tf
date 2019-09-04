// Configure the Google Cloud provider
provider "google" {
 credentials = "${file("${var.credentials}")}"
 project     = "${var.gcp_project}" 
 region      = "${var.region}"
}



// Enabling API's 

resource "google_project_service" "storage-json-api" {
  project = "${var.gcp_project}"
  service = "${var.storage_json_api}"

  disable_dependent_services = true
}

resource "google_project_service" "cloud-storage-api" {
  project = "${var.gcp_project}"
  service = "${var.cloud_storage_api}"

  disable_dependent_services = true
}







/*
resource "google_project_services" "project" {
  project = "${var.gcp_project}"
  services   = ["iam.googleapis.com", "cloudresourcemanager.googleapis.com", "compute.googleapis.com", "iamcredentials.googleapis.com", "logging.googleapis.com", "admin.googleapis.com", "appengine.googleapis.com", "appengineflex.googleapis.com", "bigquery-json.googleapis.com", "bigqueryconnection.googleapis.com", "bigquerydatatransfer.googleapis.com", "bigqueryreservation.googleapis.com", "bigquerystorage.googleapis.com", "bigtable.googleapis.com", "bigtabletableadmin.googleapis.com", "cloudapis.googleapis.com", "cloudasset.googleapis.com", "cloudbilling.googleapis.com", "cloudbuild.googleapis.com", "clouddebugger.googleapis.com", "clouderrorreporting.googleapis.com", "cloudfunctions.googleapis.com", "cloudidentity.googleapis.com", "cloudkms.googleapis.com", "cloudlatencytest.googleapis.com", "cloudmonitoring.googleapis.com", "cloudprofiler.googleapis.com", "cloudscheduler.googleapis.com", "cloudsearch.googleapis.com", "cloudshell.googleapis.com", "cloudtasks.googleapis.com", "cloudtrace.googleapis.com", "container.googleapis.com", "containeranalysis.googleapis.com", "containerregistry.googleapis.com", "containerscanning.googleapis.com", "customsearch.googleapis.com", "dataflow.googleapis.com", "dataproc.googleapis.com", "datastore.googleapis.com", "deploymentmanager.googleapis.com", "dns.googleapis.com", "endpoints.googleapis.com", "firestore.googleapis.com", "firewallinsights.googleapis.com", "googlecloudmessaging.googleapis.com", "iap.googleapis.com", "pubsub.googleapis.com", "replicapool.googleapis.com", "replicapoolupdater.googleapis.com", "resourceviews.googleapis.com", "run.googleapis.com", "runtimeconfig.googleapis.com", "serviceusage.googleapis.com", "servicebroker.googleapis.com", "serviceconsumermanagement.googleapis.com", "servicecontrol.googleapis.com", "servicemanagement.googleapis.com", "servicenetworking.googleapis.com", "sourcerepo.googleapis.com", "spanner.googleapis.com", "sql-component.googleapis.com", "sqladmin.googleapis.com", "stackdriver.googleapis.com", "storage-api.googleapis.com", "storage-component.googleapis.com", "storagetransfer.googleapis.com", "vmmigration.googleapis.com"]
}
*/

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

  source_ranges = "${var.subnet1_source_ranges}"
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

  source_ranges = "${var.subnet2_source_ranges}"
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


//Reserving static IP 1
resource "google_compute_address" "ip_address1" {
  name = "${var.ip_address_name1}"
}


//Reserving static IP 2
resource "google_compute_address" "ip_address2" {
  name = "${var.ip_address_name2}"
}


//VPN Tunnel 1
resource "google_compute_vpn_tunnel" "tunnel1" {
  name          = "${var.vpn_tunnel1}"
  peer_ip       = "${google_compute_address.ip_address2.address}"
  shared_secret = "a secret message"

  target_vpn_gateway = "${google_compute_vpn_gateway.gateway1.self_link}"

  local_traffic_selector = "${var.local_traffic_selector}"

  depends_on = [
    "google_compute_address.ip_address2",
     "google_compute_forwarding_rule.fr_esp",
    "google_compute_forwarding_rule.fr_udp500",
    "google_compute_forwarding_rule.fr_udp4500",
    
  ]
}



//Forwarding Rule VPN Tunnel 1 - A
resource "google_compute_forwarding_rule" "fr_esp" {
  name        = "${var.fr_esp}"
  ip_protocol = "${var.fr_esp_ip_protocol}"
  ip_address  = "${google_compute_address.ip_address1.address}"
  target      = "${google_compute_vpn_gateway.gateway1.self_link}"
}

//Forwarding Rule VPN Tunnel 1 - B
resource "google_compute_forwarding_rule" "fr_udp500" {
  name        = "${var.fr_udp500}"
  ip_protocol = "${var.fr_udp500_ip_protocol}"
  port_range  = "${var.fr_udp500_port_range}"
  ip_address  = "${google_compute_address.ip_address1.address}"
  target      = "${google_compute_vpn_gateway.gateway1.self_link}"
}

//Forwarding Rule VPN Tunnel 1 - C
resource "google_compute_forwarding_rule" "fr_udp4500" {
  name        = "${var.fr_udp4500}"
  ip_protocol = "${var.fr_udp4500_ip_protocol}"
  port_range  = "${var.fr_udp4500_port_range}"
  ip_address  = "${google_compute_address.ip_address1.address}"
  target      = "${google_compute_vpn_gateway.gateway1.self_link}"
}



/*
//VPN Tunnel 2
resource "google_compute_vpn_tunnel" "tunnel2" {
  name          = "${var.vpn_tunnel2}"
  peer_ip       = "${google_compute_address.ip_address1.address}"
  shared_secret = "a secret message"

  target_vpn_gateway = "${google_compute_vpn_gateway.gateway2.self_link}"

  local_traffic_selector = "${var.local_traffic_selector}"

  depends_on = [
    "google_compute_address.ip_address2",
     "google_compute_forwarding_rule.fr_esp",
    "google_compute_forwarding_rule.fr_udp500",
    "google_compute_forwarding_rule.fr_udp4500",
    
  ]
}
*/




// IAM Project Owner
resource "google_project_iam_member" "project-owner" {
  project = "${var.gcp_project}"
  role    = "${var.iam_role}"

  member  = "${var.iam_member}"
}

//Service Account
resource "google_service_account" "service-acc" {
  account_id   = "project-service-account"
  display_name = "Project Service Account"
}

//Service Account Key
resource "google_service_account_key" "mykey" {
  service_account_id = "${google_service_account.service-acc.name}"
}

//Storage Bucket
resource "google_storage_bucket" "storage_bucket" {
  name     = "${var.storage_bucket_name}"
  location = "${var.storage_bucket_location}"
  storage_class = "${var.storage_bucket_class}"

  lifecycle_rule {

  action{
      type ="${var.storage_bucket_lcr_action_type}"
      }


   condition {
      age ="${var.storage_bucket_lcr_condition_age}"
      }
  }


  versioning{
      enabled = "${var.storage_bucket_versioning}"
      }


}


//Storage Bucket ACL
resource "google_storage_bucket_acl" "storage_bucket" {
  bucket = "${google_storage_bucket.storage_bucket.name}"
  role_entity = "${var.storage_bucket_acl_role}"

 
}



