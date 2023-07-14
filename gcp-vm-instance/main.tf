// creating a ssh security group
resource "google_compute_firewall" "ssh" {
  name = "allow-ssh"
  network = "default"
  allow {
    protocol = "tcp"
    ports = ["22"]
  }
  // allow traffic from everywhere to instances with an ssh tag
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["ssh"]
}

// creating a webserver security group
resource "google_compute_firewall" "http-server" {
  name = "allow-http-traffic"
  network = "default"
  allow {
    protocol = "tcp"
    ports = ["80"]
  }
  // allow traffic from everywhere to instances with an http-server tag
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server"]
}

// creating a webserver instance
resource "google_compute_instance" "default" {
  name = "webserver"
  machine_type = "e2-micro"
  zone = "us-east1-b"
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }
  network_interface {
    network = "default"
    access_config {
      // including this secion to give vm an external ip for accessing the webserver
    }
  }
  // install webserver metadata script
  metadata_startup_script = "sudo apt-get update && sudo apt-get install apache2 -y && echo '<!doctype html><html><body><h1>Hello world.!</h1></body></html>' | sudo tee /var/www/html/index.html"
  metadata = {
    "foo" = "bar"
  }
  // apply the firewall rule to allow external ips to access this instance
  tags = ["ssh", "http-server"]
  depends_on = [
    google_compute_firewall.ssh,
    google_compute_firewall.http-server
  ]
}

// return the public ip of created instance
output "ip" {
  value = "${google_compute_instance.default.network_interface.0.access_config.0.nat_ip}"
}
