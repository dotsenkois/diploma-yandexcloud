variable "ssh_user" {
  description = "name of user"
  type        = string
  default     = "dotsenkois"
}
variable "ssh_pub_key" {
  description = "Path to public ssh key"
  type        = string
  default     = "../netology.pub"
}