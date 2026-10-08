# alb module
Public ALB with HTTP->HTTPS redirect, optional HTTPS listener (ACM var), access logs, drop-invalid-headers.
```hcl
module "alb" { source = "../../modules/alb" vpc_id = module.vpc.vpc_id public_subnet_ids = module.vpc.public_subnet_ids alb_sg_id = module.sgs.alb_sg_id target_ips = module.app.private_ips }
```
