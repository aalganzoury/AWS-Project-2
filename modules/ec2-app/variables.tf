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

variable "ami_id" {
  type    = string
  default = "ami-0c55b159cbfafe1f0"
}
variable "instance_type" {
  type    = string
  default = "t3.micro"
}
variable "app_subnet_ids" {
  type = list(string)
}
variable "app_sg_id" {
  type = string
}
variable "instance_profile_name" {
  type = string
}
variable "app_port" {
  type    = number
  default = 8080
}
variable "key_name" {
  type    = string
  default = ""
}
