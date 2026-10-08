# Athena workgroup (encrypted results) + Glue DB/table with partition projection.
terraform {
  required_version = ">= 1.6"
  required_providers { aws = { source = "hashicorp/aws", version = "~> 5.0" } }
}

resource "aws_s3_bucket" "results" {
  bucket = var.results_bucket_name
  tags   = var.tags
}
resource "aws_s3_bucket_public_access_block" "results" {
  bucket                  = aws_s3_bucket.results.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
resource "aws_athena_workgroup" "this" {
  name = "flowlogs-wg"
  configuration {
    result_configuration { output_location = "s3://${aws_s3_bucket.results.id}/results/" }
  }
  tags = var.tags
}
resource "aws_glue_catalog_database" "this" {
  name = var.database_name
}
resource "aws_glue_catalog_table" "flow" {
  name          = var.table_name
  database_name = aws_glue_catalog_database.this.name
  table_type    = "EXTERNAL_TABLE"
  parameters = {
    "projection.enabled"           = "true"
    "projection.day.type"          = "date"
    "projection.day.range"         = "2026/01/01,NOW"
    "projection.day.format"        = "yyyy/MM/dd"
    "projection.day.interval"      = "1"
    "projection.day.interval.unit" = "DAYS"
    "storage.location.template"    = "s3://${var.log_bucket}/AWSLogs/111111111111/vpcflowlogs/$${day}/"
  }
  storage_descriptor {
    location      = "s3://${var.log_bucket}/AWSLogs/111111111111/vpcflowlogs/"
    input_format  = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat"
    ser_de_info {
      name                  = "parquet"
      serialization_library = "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe"
    }
    columns {
      name = "version"
      type = "int"
    }
    columns {
      name = "srcaddr"
      type = "string"
    }
    columns {
      name = "dstaddr"
      type = "string"
    }
    columns {
      name = "action"
      type = "string"
    }
    columns {
      name = "bytes"
      type = "bigint"
    }
  }
}
