terraform {
  required_version = ">=0.14"

  required_providers {
    google = ">= 3.3"
  }
}

provider "google" {
  # replace GCP_PROJECT_ID with your project
  project = "GCP_PROJECT_ID"
}

# enable the google cloud service
# note - uncomment if the service is already not enabled in your gcp project
/* resource "google_project_service" "enable_api" {
  service = "run.googleapis.com"
  disable_on_destroy = true
}
 */

# create cloud run service
resource "google_cloud_run_service" "deploy_service" {
  name     = "app"
  location = "us-central1"

  template {
    spec {
      containers {
        image = "gcr.io/google-samples/hello-app:1.0"
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

  # wait for the cloud run service to be enabled
  # note - uncomment the below block if google_project_service.enable_api is uncommented
  /* depends_on = [
    google_project_service.enable_api
  ] */
}

# allow unauthenticated invocations
resource "google_cloud_run_service_iam_member" "run_all_users" {
  location = google_cloud_run_service.deploy_service.location
  service  = google_cloud_run_service.deploy_service.name

  role   = "roles/run.invoker"
  member = "allUsers"
}

output "service_url" {
  value = google_cloud_run_service.deploy_service.status[0].url
}
