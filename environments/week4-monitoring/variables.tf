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

variable "vpc_id" {
  type    = string
  default = "vpc-0123456789abcdef0"
}
variable "enable_traffic_mirroring" {
  type    = bool
  default = false
}
variable "enable_guardduty" {
  type    = bool
  default = false
}
variable "enable_auto_isolate" {
  type    = bool
  default = false
}
