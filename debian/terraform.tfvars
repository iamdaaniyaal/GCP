region = "us-central1"
gcp_project = "script-project-249010"
vpc1_name = "dev"
vpc2_name = "prod"
credentials= "credentials.json"
subnet1_cidr= "10.10.0.0/24"
subnet2_cidr= "10.10.1.0/24"
subnet1_source_ranges =  ["0.0.0.0/0"]
subnet2_source_ranges =  ["0.0.0.0/0"]
firewall_protocol1 = "icmp"
firewall_protocol2 = "smtp"
firewall_ports = ["22","80", "8080"]
vpn_gateway1 = "vpn-gateway-1"
vpn_gateway2 = "vpn-gateway-2"
ip_address_name1 = "ip-address1"
ip_address_name2 = "ip-address2"
fr_esp = "fr-esp"
fr_esp_ip_protocol = "ESP"
fr_udp500 = "fr-udp500"
fr_udp500_ip_protocol = "UDP"
fr_udp500_port_range = "500"
fr_udp4500 = "fr-udp4500"
fr_udp4500_ip_protocol = "UDP"
fr_udp4500_port_range = "4500"
vpn_tunnel1 = "vpn-tunnel-1"
vpn_tunnel2 = "vpn-tunnel-2"
local_traffic_selector = ["0.0.0.0/0"]
iam_role = "roles/viewer"
iam_member =  "user:moniece1693@gmail.com"
service_account_id = "project-service-account"
service_account_display_name = "Project Service Account"
storage_bucket_name = "terraform-gcp-bucket-1a"
storage_bucket_location = "EU"
storage_bucket_class = "MULTI_REGIONAL"
storage_bucket_lcr_action_type = "Delete"
storage_bucket_lcr_condition_age = "10"
storage_bucket_versioning = "true"
storage_bucket_acl_role =  [
    "OWNER:user-iamdaaniyaal@gmail.com", 
	"READER:user-authentick9@gmail.com" ]

dialogflow_api = "dialogflow.googleapis.com"

compute_instance_name_in_vpc_1 = "dev-instance"
compute_instance_name_in_vpc_2 = "prod-instance"
