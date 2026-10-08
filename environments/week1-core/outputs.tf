output "vpc_id" { value = module.vpc.vpc_id }
output "alb_dns" { value = module.alb.alb_dns_name }
output "app_private_ips" { value = module.app.private_ips }
output "db_endpoint" { value = module.db.db_endpoint }
