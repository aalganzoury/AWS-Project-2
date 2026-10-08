output "log_bucket" { value = module.flow.log_bucket }
output "sns_topic" { value = module.mon.sns_topic_arn }
output "quarantine_sg" { value = module.ir.quarantine_sg_id }
