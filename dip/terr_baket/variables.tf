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

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "vpc_name" {
  type        = string
  default     = "main_network"
  description = "VPC net & subnet name"
}


