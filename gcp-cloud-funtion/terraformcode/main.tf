terraform {
  required_version = ">=0.14"
  backend "local" {}

  required_providers {
    google = ">= 3.3"
  }
}

provider "google" {
  project = var.project_id
  region  = var.location
}

locals {
  timestamp = formatdate("YYMMDDhhmmss", timestamp())
}

# compress source code
data "archive_file" "source" {
  type        = "zip"
  source_dir  = "${path.root}/../src"
  output_path = "${path.root}/../generated/src-${local.timestamp}.zip"
}

# storage bucket that will host the source code
resource "google_storage_bucket" "bucket" {
  name = "tf-cf-bucket-${local.timestamp}"

  location = var.bucket_location
}

# add source code to storage bucket
resource "google_storage_bucket_object" "archive" {
  depends_on = [
    google_storage_bucket.bucket,
    data.archive_file.source
  ]

  name   = "${data.archive_file.source.output_md5}.zip"
  bucket = google_storage_bucket.bucket.name

  source       = data.archive_file.source.output_path
  content_type = "application/zip"
}

# create generation1 cloudfunction
resource "google_cloudfunctions_function" "function" {
  depends_on = [
    google_storage_bucket.bucket,
    google_storage_bucket_object.archive
  ]

  name        = "tf-nodejs-cf-${local.timestamp}"
  description = "learning cf through terraform"
  runtime     = "nodejs16"

  project = var.project_id
  region  = var.location

  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket.bucket.name
  source_archive_object = google_storage_bucket_object.archive.name
  trigger_http          = true
  timeout               = 60

  # name of the function that will be executed by nodejs
  entry_point = "helloWorld"
  labels = {
    purpose = "learning"
  }

  max_instances = 1
  min_instances = 1
}

# iam entry for all users
resource "google_cloudfunctions_function_iam_member" "invoker" {
  depends_on = [
    google_cloudfunctions_function.function
  ]

  project        = google_cloudfunctions_function.function.project
  region         = var.location
  cloud_function = google_cloudfunctions_function.function.name

  role   = "roles/cloudfunctions.invoker"
  member = "allUsers"
}
