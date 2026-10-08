# Week2 composes hybrid building blocks. Fill VPC IDs/subnets from week1 outputs (or deploy hub/prod/dev VPCs here).
module "tgw" {
  source              = "../../modules/transit-gateway"
  hub_vpc_id          = var.hub_vpc_id
  hub_tgw_subnet_ids  = var.hub_tgw_subnets
  prod_vpc_id         = var.prod_vpc_id
  prod_tgw_subnet_ids = var.prod_tgw_subnets
  dev_vpc_id          = var.dev_vpc_id
  dev_tgw_subnet_ids  = var.dev_tgw_subnets
  hub_cidr            = var.hub_cidr
  prod_cidr           = var.prod_cidr
  dev_cidr            = var.dev_cidr
  tags                = var.tags
}

module "vpn" {
  source              = "../../modules/site-to-site-vpn"
  transit_gateway_id  = module.tgw.tgw_id
  customer_gateway_ip = var.customer_gateway_ip
  use_bgp             = var.use_bgp
  tags                = var.tags
}

module "onprem" {
  source              = "../../modules/onprem-simulator"
  vpn_tunnel1_address = module.vpn.tunnel1_address
  tags                = var.tags
}

module "peering_demo" {
  source           = "../../modules/vpc-peering"
  requester_vpc_id = var.prod_vpc_id == "" ? "vpc-0123456789abcdef0" : var.prod_vpc_id
  accepter_vpc_id  = var.hub_vpc_id == "" ? "vpc-0123456789abcdef1" : var.hub_vpc_id
  requester_cidr   = var.prod_cidr
  accepter_cidr    = var.hub_cidr
  tags             = var.tags
}

module "endpoints_demo" {
  source          = "../../modules/vpc-endpoints"
  vpc_id          = var.prod_vpc_id == "" ? "vpc-0123456789abcdef0" : var.prod_vpc_id
  route_table_ids = []
  subnet_ids      = var.prod_tgw_subnets
  tags            = var.tags
}

module "client_vpn" {
  source            = "../../modules/client-vpn"
  enable_client_vpn = var.enable_client_vpn
  vpc_id            = var.prod_vpc_id
  subnet_ids        = var.prod_tgw_subnets
  tags              = var.tags
}
