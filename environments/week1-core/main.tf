module "vpc" {
  source             = "../../modules/vpc"
  vpc_cidr           = var.vpc_cidr
  azs                = var.azs
  single_nat_gateway = true
  name_prefix        = "prod"
  environment        = var.environment
  tags               = var.tags
}

module "nacls" {
  source            = "../../modules/nacl"
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  app_subnet_ids    = module.vpc.app_subnet_ids
  data_subnet_ids   = module.vpc.data_subnet_ids
  tags              = var.tags
}

module "sgs" {
  source   = "../../modules/security-groups"
  vpc_id   = module.vpc.vpc_id
  vpc_cidr = var.vpc_cidr
  tags     = var.tags
}

module "ssm" {
  source      = "../../modules/ssm-access"
  environment = var.environment
  tags        = var.tags
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

module "db" {
  source          = "../../modules/rds"
  data_subnet_ids = module.vpc.data_subnet_ids
  db_sg_id        = module.sgs.db_sg_id
  multi_az        = var.db_multi_az
  tags            = var.tags
}
