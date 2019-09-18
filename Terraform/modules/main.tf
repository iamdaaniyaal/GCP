provider "google" {

  region      = "us-central1"
}





data "template_file" "vpn-cloudformation" {
  template = "${file("${path.module}/conf.wp-conf.php")}"
}
