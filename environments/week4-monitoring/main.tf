module "flow" {
  source = "../../modules/flow-logs"
  vpc_id = var.vpc_id
  tags   = var.tags
}

module "athena" {
  source     = "../../modules/athena-flowlogs"
  log_bucket = module.flow.log_bucket
  tags       = var.tags
}

module "mirror" {
  source                   = "../../modules/traffic-mirroring"
  enable_traffic_mirroring = var.enable_traffic_mirroring
  tags                     = var.tags
}

module "mon" {
  source         = "../../modules/monitoring"
  flow_log_group = module.flow.cw_log_group
  tags           = var.tags
}

module "gd" {
  source           = "../../modules/guardduty"
  enable_guardduty = var.enable_guardduty
  tags             = var.tags
}

module "ir" {
  source              = "../../modules/ir-isolation"
  vpc_id              = var.vpc_id
  enable_auto_isolate = var.enable_auto_isolate
  tags                = var.tags
}
