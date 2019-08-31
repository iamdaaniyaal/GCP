variable "region" {}
variable "gcp_project" {}
variable "credentials" {}
variable "name" {}
variable "subnet_cidr" {}
variable "ssh_public_key_filepath" {
  description = "Filepath for the ssh public key"
  type        = "string"
  default     = "ubuntu.pub"
}
variable "gcp_zone" {
  description = "Filepath for the ssh public key"
  type        = "string"
  default     = "europe-west2-a"
}
