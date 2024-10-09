variable "token" {
  type        = string
  description = "y0_AgAAAABIW9U-AATuwQAAAAEPI2S8AABMd2fgsN5MRI6C5WYI6FEH0_HXvQ"
}

variable "cloud_id" {
  type        = string
  description = "b1ga397ao4qr22ofjshl"
}

variable "folder_id" {
  type        = string
  description = "b1golull73609mhvvdf6"
}

variable "default_zone_a" {
  type    = string
  default = "ru-central1-a"
}

variable "default_zone_b" {
  type    = string
  default = "ru-central1-b"
}

variable "default_zone_d" {
  type    = string
  default = "ru-central1-d"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "Name for VPC network & subnets"
}

variable "public_image" {
  type        = string
  default     = "fd8vljd295nqdaoogf3g"
  description = "Yandex.Compute image ID"
}


variable "public_resources" {
  type = map(number)
  default = {
    cores          = 2
    memory         = 4
    core_fraction  = 20
    size           = 60
 }
}

variable "ssh_public_key_path" {
  type    = string
  default = "~/.ssh/id_rsa.pub"  # Укажите здесь путь к вашему открытому ключу SSH
}

variable "public_resources_node" {
  type = map(number)
  default = {
    cores          = 2
    memory         = 4
    core_fraction  = 20
    size           = 60
 }
}


# Определение списка нод
locals {
  nodes = {
    "node1" = {
      zone      = var.default_zone_b
      subnet_id = "central1-b"
      ip_offset = 2
      ssh_key   = var.ssh_public_key_path
    },
    "node2" = {
      zone      = var.default_zone_d
      subnet_id = "central1-d"
      ip_offset = 3
      ssh_key   = var.ssh_public_key_path
    }
  }
}
