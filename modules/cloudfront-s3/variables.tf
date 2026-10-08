variable "tags" {
  type    = map(string)
  default = { Project = "secure-net-lab", Owner = "lab-owner-placeholder" }
}
variable "environment" {
  type    = string
  default = "lab"
}

variable "bucket_name" {
  type    = string
  default = "secure-net-lab-origin-111111111111"
}
variable "geo_restriction_type" {
  type    = string
  default = "none"
}
variable "geo_locations" {
  type    = list(string)
  default = []
}
variable "default_root_object" {
  type    = string
  default = "index.html"
}
