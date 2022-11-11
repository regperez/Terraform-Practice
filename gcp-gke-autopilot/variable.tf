variable "gke_master_ipv4_cidr_block" {
  type    = string
  default = "10.0.128.0/28"
}

variable "region" {
  default = "us-east1"
}

variable "zone" {
  default = "us-east1-b"
}