variable "project_name" { default = "terraformtest" }
variable "region" { default = "europe-west1" }

locals {
  hostname = "protocmodify-996655.endpoints.${google_project.project.project_id}.cloud.goog"
}

provider "google" {
 region = "${var.region}"
}

resource "random_id" "id" {
 byte_length = 4
 prefix      = "${var.project_name}"
}

resource "google_project" "project" {
 name            = "${var.project_name}"
 project_id      = "${random_id.id.hex}"
}

resource "google_endpoints_service" "grpc_service" {
  service_name  = "${local.hostname}"
  project       = "${google_project.project.project_id}"
  grpc_config = <<EOF
type: google.api.Service
config_version: 3
name: ${local.hostname}
usage:
  rules:
  - selector: endpoints.examples.bookstore.Bookstore.ListShelves
    allow_unregistered_calls: true
EOF
  protoc_output = "${file("protoc_output.pb")}"
}
