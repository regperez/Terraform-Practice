resource "google_container_cluster" "aig-k8s" {
  provider                 = google-beta

  name                     = "aig-k8s"
  location                 = var.region

  network                  = "vpc-aig"
  subnetwork               = "subred-k8s"

  private_cluster_config {
    enable_private_endpoint = false
    enable_private_nodes    = true
    master_ipv4_cidr_block  = var.gke_master_ipv4_cidr_block
  }


  maintenance_policy {
    recurring_window {
      start_time = "2021-06-18T00:00:00Z"
      end_time   = "2050-01-01T04:00:00Z"
      recurrence = "FREQ=WEEKLY"
    }
  }
  
  # Enable Autopilot for this cluster
  enable_autopilot = true

  # Configuration options for the Release channel feature, which provide more control over automatic upgrades of your GKE clusters.
  release_channel {
    channel = "REGULAR"
  }
}