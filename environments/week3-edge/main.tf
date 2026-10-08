module "edge" {
  source = "../../modules/cloudfront-s3"
  tags   = var.tags
}

module "waf_cf" {
  source              = "../../modules/waf-cloudfront"
  providers           = { aws.useast1 = aws.useast1 }
  log_destination_arn = var.waf_log_arn
  tags                = var.tags
}

module "waf_alb" {
  source              = "../../modules/waf-alb"
  alb_arn             = var.alb_arn == "" ? "arn:aws:elasticloadbalancing:us-east-1:111111111111:loadbalancer/app/lab/0123456789abcdef" : var.alb_arn
  log_destination_arn = var.waf_log_arn
  tags                = var.tags
}

module "r53" {
  source         = "../../modules/route53-health"
  enable_dns     = var.enable_dns
  domain_name    = var.domain_name
  hosted_zone_id = var.hosted_zone_id
  alb_dns_name   = var.alb_dns_name
  tags           = var.tags
}

module "ga" {
  source                    = "../../modules/global-accelerator"
  enable_global_accelerator = var.enable_global_accelerator
  alb_arn                   = var.alb_arn
  tags                      = var.tags
}
