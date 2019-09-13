variable "region" {}
variable "gcp_project" {}
variable "credentials" {}
variable "vpc1_name" {}
variable "vpc2_name" {}
variable "subnet1_cidr" {}
variable "subnet2_cidr" {}
variable "subnet1_source_ranges" {}
variable "subnet2_source_ranges" {}
variable "firewall_protocol1" {}
variable "firewall_protocol2" {}
variable "firewall_ports" {
  type = list(string)
}

variable "vpn_gateway1" {}
variable "vpn_gateway2" {}

variable "ip_address_name1" {}
variable "ip_address_name2" {}



variable "fr_esp" {}
variable "fr_esp_ip_protocol" {}


variable "fr_udp500" {}
variable "fr_udp500_ip_protocol" {}
variable "fr_udp500_port_range" {}


variable "fr_udp4500" {}
variable "fr_udp4500_ip_protocol" {}
variable "fr_udp4500_port_range" {}



variable "vpn_tunnel1" {}
variable "vpn_tunnel2" {}

variable "local_traffic_selector" {}


variable "iam_role" {}
variable "iam_member" {}

variable "service_account_id" {}
variable "service_account_display_name" {}


variable "storage_bucket_name" {}
variable "storage_bucket_location" {}
variable "storage_bucket_class" {}
variable "storage_bucket_lcr_action_type" {}
variable "storage_bucket_lcr_condition_age" {}
variable "storage_bucket_versioning" {}
variable "storage_bucket_acl_role" {
  type = list(string)
}



variable "dialogflow_api" {}

variable "compute_instance_name_in_vpc_1" {}
variable "compute_instance_name_in_vpc_2" {}

