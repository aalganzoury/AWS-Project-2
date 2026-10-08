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

variable "alb_arn" {
  type    = string
  default = ""
}
variable "alb_dns_name" {
  type    = string
  default = ""
}
variable "enable_dns" {
  type    = bool
  default = false
}
variable "domain_name" {
  type    = string
  default = "app.example.com"
}
variable "hosted_zone_id" {
  type    = string
  default = ""
}
variable "enable_global_accelerator" {
  type    = bool
  default = false
}
variable "waf_log_arn" {
  type    = string
  default = ""
}
