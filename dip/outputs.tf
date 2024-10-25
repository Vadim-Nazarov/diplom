output "master_internal_ipv4" {
  value = yandex_compute_instance.master.network_interface[0].ip_address
}
output "master_public_ipv4" {
  value = yandex_compute_instance.master.network_interface[0].nat_ip_address
}

