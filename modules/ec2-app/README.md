# ec2-app module
Private EC2 (IMDSv2 required, encrypted EBS, no public IP) with tiny Python web app on 8080.
```hcl
module "app" { source = "../../modules/ec2-app" app_subnet_ids = module.vpc.app_subnet_ids app_sg_id = module.sgs.app_sg_id instance_profile_name = module.ssm.instance_profile_name }
```
Test via SSM: `aws ssm send-command --instance-ids <id> --document-name AWS-RunShellScript --parameters commands='curl -s localhost:8080'`.
