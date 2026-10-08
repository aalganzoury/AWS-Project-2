# athena-flowlogs module
Workgroup + Glue table (partition projection) for flow-log Parquet. Queries in `analysis/athena/`.
```hcl
module "ath" { source = "../../modules/athena-flowlogs" log_bucket = module.fl.log_bucket }
```
