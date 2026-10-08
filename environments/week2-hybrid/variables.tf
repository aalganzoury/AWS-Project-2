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

variable "hub_cidr" {
  type    = string
  default = "10.0.0.0/16"
}
variable "prod_cidr" {
  type    = string
  default = "10.1.0.0/16"
}
variable "dev_cidr" {
  type    = string
  default = "10.2.0.0/16"
}
variable "hub_vpc_id" {
  type    = string
  default = ""
}
variable "prod_vpc_id" {
  type    = string
  default = ""
}
variable "dev_vpc_id" {
  type    = string
  default = ""
}
variable "hub_tgw_subnets" {
  type    = list(string)
  default = []
}
variable "prod_tgw_subnets" {
  type    = list(string)
  default = []
}
variable "dev_tgw_subnets" {
  type    = list(string)
  default = []
}
variable "customer_gateway_ip" {
  type    = string
  default = "203.0.113.12"
}
variable "use_bgp" {
  type    = bool
  default = false
}
variable "enable_client_vpn" {
  type    = bool
  default = false
}
