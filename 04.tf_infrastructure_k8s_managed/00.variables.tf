
variable "yc_zone" {
  type    = string
  default = "ru-central1-a"
}

variable "HostsPath" {
  type    = string
  default = "../05.ansible-db/inventory/inventory.yml"
}
variable "ssh_user" {
  description = "name of user"
  type        = string
  default     = "ubuntu"
}
variable "ssh_pub_key" {
  description = "Path to public ssh key"
  type        = string
  default     = "~/.ssh/netology.pub"
}