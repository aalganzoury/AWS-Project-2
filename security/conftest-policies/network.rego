package main

# Deny 0.0.0.0/0 ingress except ALB 80/443 (documented edge).
deny[msg] {
  input.resource_type == "aws_security_group_rule"
  input.values.cidr_blocks[_] == "0.0.0.0/0"
  input.values.type == "ingress"
  not startswith(input.values.description, "ALB public")
  msg := sprintf("SG rule %v allows 0.0.0.0/0 ingress without ALB exception", [input.address])
}

# Deny public RDS.
deny[msg] {
  input.resource_type == "aws_db_instance"
  input.values.publicly_accessible == true
  msg := sprintf("RDS %v must not be publicly accessible", [input.address])
}

# Require EBS encryption.
deny[msg] {
  input.resource_type == "aws_ebs_volume"
  input.values.encrypted != true
  msg := sprintf("EBS volume %v must be encrypted", [input.address])
}

# Require IMDSv2.
deny[msg] {
  input.resource_type == "aws_instance"
  input.values.metadata_options[_].http_tokens != "required"
  msg := sprintf("EC2 %v must require IMDSv2 (http_tokens=required)", [input.address])
}
