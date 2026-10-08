output "vpc_id" { value = module.vpc.vpc_id }
output "alb_dns" { value = module.alb.alb_dns_name }
output "cf_domain" { value = module.edge.distribution_domain }
