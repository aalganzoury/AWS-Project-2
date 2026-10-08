variable "project" {
  description = "Project tag prefix"
  type        = string
  default     = "secure-net-lab"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "lab"
}

variable "tags" {
  description = "Common tags merged into every resource"
  type        = map(string)
  default = {
    Project    = "secure-net-lab"
    Owner      = "lab-owner-placeholder"
    CostCenter = "lab-000"
  }
}

variable "vpc_id" {
  type = string
}
variable "public_subnet_ids" {
  type = list(string)
}
variable "alb_sg_id" {
  type = string
}
variable "acm_certificate_arn" {
  type    = string
  default = ""
}
variable "app_port" {
  type    = number
  default = 8080
}
variable "target_ips" {
  type    = list(string)
  default = []
}
variable "access_log_bucket" {
  type    = string
  default = ""
}
variable "access_log_prefix" {
  type    = string
  default = "alb-logs"
}
