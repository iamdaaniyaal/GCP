variable "region" {}
variable "gcp_project" {}
variable "credentials" {}
variable "vpc1_name" {}
variable "vpc2_name" {}
variable "subnet1_cidr" {}
variable "subnet2_cidr" {}
variable "firewall_protocol1" {}
variable "firewall_protocol2" {}
variable "firewall_ports" {
	type = list(string)
}

variable "vpn_gateway1" {}
variable "vpn_gateway2" {}
