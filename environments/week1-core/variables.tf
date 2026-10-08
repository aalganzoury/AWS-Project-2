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
variable "db_multi_az" {
  type    = bool
  default = false
}
