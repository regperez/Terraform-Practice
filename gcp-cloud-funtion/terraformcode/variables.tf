variable "project_id" {
  type = string
  # replace GCP_PROJECT_ID with your project
  default = "GCP_PROJECT_ID"
}

variable "location" {
  type    = string
  default = "us-central1"
}

variable "bucket_location" {
  type    = string
  default = "US"
}
