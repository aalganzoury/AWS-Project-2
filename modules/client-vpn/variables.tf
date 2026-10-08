variable "tags" {
  type = map(string)
  default = {
    Project = "secure-net-lab"
    Owner   = "lab-owner-placeholder"
  }
}
variable "environment" {
  type    = string
  default = "lab"
}

variable "enable_client_vpn" {
  type    = bool
  default = false
}
variable "vpc_id" {
  type    = string
  default = ""
}
variable "subnet_ids" {
  type    = list(string)
  default = []
}
variable "client_cidr" {
  type    = string
  default = "10.10.0.0/22"
}
variable "server_cert_arn" {
  type    = string
  default = ""
}
variable "root_cert_arn" {
  type    = string
  default = ""
}
variable "target_network_cidr" {
  type    = string
  default = "10.1.0.0/16"
}
