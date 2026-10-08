# OPTIONAL Client VPN (default OFF - costly). Mutual TLS via ACM ARNs; easy-rsa documented in README.
terraform {
  required_version = ">= 1.6"
  required_providers { aws = { source = "hashicorp/aws", version = "~> 5.0" } }
}

resource "aws_cloudwatch_log_group" "client_vpn" {
  count             = var.enable_client_vpn ? 1 : 0
  name              = "client-vpn-connections"
  retention_in_days = 30
  tags              = var.tags
}

resource "aws_ec2_client_vpn_endpoint" "this" {
  count                  = var.enable_client_vpn ? 1 : 0
  description            = "lab-client-vpn"
  server_certificate_arn = var.server_cert_arn
  client_cidr_block      = var.client_cidr
  split_tunnel           = true # WHY: only VPC traffic via VPN
  authentication_options {
    type                       = "certificate-authentication"
    root_certificate_chain_arn = var.root_cert_arn
  }
  connection_log_options {
    enabled              = true
    cloudwatch_log_group = aws_cloudwatch_log_group.client_vpn[0].name
  }
  tags = var.tags
}

resource "aws_ec2_client_vpn_network_association" "this" {
  count                  = var.enable_client_vpn ? length(var.subnet_ids) : 0
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.this[0].id
  subnet_id              = var.subnet_ids[count.index]
}

resource "aws_ec2_client_vpn_authorization_rule" "target" {
  count                  = var.enable_client_vpn ? 1 : 0
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.this[0].id
  target_network_cidr    = var.target_network_cidr
  authorize_all_groups   = true
}
