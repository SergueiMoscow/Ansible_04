###cloud vars
variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "subnet_id" {
  type    = string
}

variable "vms_ssh_user" {
  type    = string
  default = "vm_user"
}

variable "image_id" {
  type = string
  default = "fd8avksksdmbc77l1s7t"
}

variable "preemptible" {
  type = bool
  default = true
}