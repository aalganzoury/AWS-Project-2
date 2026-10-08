output "cf_domain" { value = module.edge.distribution_domain }
output "waf_cf_arn" { value = module.waf_cf.web_acl_arn }
output "waf_alb_arn" { value = module.waf_alb.web_acl_arn }
