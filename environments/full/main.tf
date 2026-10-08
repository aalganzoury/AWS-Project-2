# Full composition with feature toggles (all optional components default OFF).
module "vpc" {
  source             = "../../modules/vpc"
  vpc_cidr           = var.vpc_cidr
  azs                = var.azs
  single_nat_gateway = true
  name_prefix        = "full"
  environment        = var.environment
  tags               = var.tags
}

module "sgs" {
  source   = "../../modules/security-groups"
  vpc_id   = module.vpc.vpc_id
  vpc_cidr = var.vpc_cidr
  tags     = var.tags
}

module "ssm" {
  source = "../../modules/ssm-access"
  tags   = var.tags
}

module "app" {
  source                = "../../modules/ec2-app"
  app_subnet_ids        = module.vpc.app_subnet_ids
  app_sg_id             = module.sgs.app_sg_id
  instance_profile_name = module.ssm.instance_profile_name
  tags                  = var.tags
}

module "alb" {
  source              = "../../modules/alb"
  vpc_id              = module.vpc.vpc_id
  public_subnet_ids   = module.vpc.public_subnet_ids
  alb_sg_id           = module.sgs.alb_sg_id
  target_ips          = module.app.private_ips
  acm_certificate_arn = var.acm_certificate_arn
  tags                = var.tags
}

module "waf_alb" {
  source  = "../../modules/waf-alb"
  alb_arn = module.alb.alb_arn
  tags    = var.tags
}

module "edge" {
  source = "../../modules/cloudfront-s3"
  tags   = var.tags
}

module "waf_cf" {
  source    = "../../modules/waf-cloudfront"
  providers = { aws.useast1 = aws.useast1 }
  tags      = var.tags
}

module "flow" {
  source = "../../modules/flow-logs"
  vpc_id = module.vpc.vpc_id
  tags   = var.tags
}

module "mon" {
  source         = "../../modules/monitoring"
  flow_log_group = module.flow.cw_log_group
  tags           = var.tags
}

module "ir" {
  source = "../../modules/ir-isolation"
  vpc_id = module.vpc.vpc_id
  tags   = var.tags
}

module "tgw" {
  source              = "../../modules/transit-gateway"
  prod_vpc_id         = module.vpc.vpc_id
  prod_tgw_subnet_ids = module.vpc.tgw_subnet_ids
  prod_cidr           = var.vpc_cidr
  tags                = var.tags
}

module "vpn" {
  source              = "../../modules/site-to-site-vpn"
  transit_gateway_id  = module.tgw.tgw_id
  customer_gateway_ip = var.customer_gateway_ip
  tags                = var.tags
}
