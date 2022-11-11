resource "google_compute_instance" "default" {
  name         = "container-os-instance"
  machine_type = "f1-micro"
  zone         = "us-east1-b"

  boot_disk {
    initialize_params {
      image = "cos-cloud/cos-89-lts"
    }
  }

metadata_startup_script = "${file("~/tf-vm-instance/start-up.sh")}"
  
  network_interface {
    subnetwork = "default"
    network_ip = "10.142.1.118"
    access_config {}
  }  
   network_interface {
    subnetwork = "subred-k8s"
    network_ip = "10.0.128.10"
    access_config {}
    }
  tags = ["proxy-nginx"]
}
