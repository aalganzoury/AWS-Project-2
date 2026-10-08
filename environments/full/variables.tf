variable "region" {
  type    = string
  default = "us-east-1"
}
variable "environment" {
  type    = string
  default = "lab"
}
variable "azs" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b"]
}
variable "tags" {
  type    = map(string)
  default = { Project = "secure-net-lab", Environment = "lab", Owner = "lab-owner-placeholder", CostCenter = "lab-000" }
}

variable "vpc_cidr" {
  type    = string
  default = "10.1.0.0/16"
}
variable "acm_certificate_arn" {
  type    = string
  default = ""
}
variable "enable_client_vpn" {
  type    = bool
  default = false
}
variable "enable_global_accelerator" {
  type    = bool
  default = false
}
variable "enable_traffic_mirroring" {
  type    = bool
  default = false
}
variable "enable_guardduty" {
  type    = bool
  default = false
}
variable "enable_dns" {
  type    = bool
  default = false
}
variable "customer_gateway_ip" {
  type    = string
  default = "203.0.113.12"
}
