resource "google_compute_firewall" "proxy-nginx" {
  name    = "default-allow-nginx"
  network = "vpc-aig"

  allow {
    protocol = "tcp"
    ports    = ["80","443"]
  }

  // Allow traffic from everywhere to instances with an proxy-nginx tag
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["proxy-nginx"]
}

output "ip" {
  value = "${google_compute_instance.default.network_interface.0.access_config.0.nat_ip}"
}