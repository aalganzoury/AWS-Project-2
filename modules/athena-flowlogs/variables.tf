variable "tags" {
  type    = map(string)
  default = { Project = "secure-net-lab", Owner = "lab-owner-placeholder" }
}
variable "environment" {
  type    = string
  default = "lab"
}

variable "log_bucket" {
  type = string
}
variable "results_bucket_name" {
  type    = string
  default = "secure-net-athena-results-111111111111"
}
variable "database_name" {
  type    = string
  default = "flowlogs"
}
variable "table_name" {
  type    = string
  default = "vpc_flow"
}
