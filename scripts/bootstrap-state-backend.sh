#!/usr/bin/env bash
# Creates S3 bucket + DynamoDB table for Terraform remote state. Run ONCE per account/region.
# Usage: AWS_PROFILE=lab-admin REGION=us-east-1 BUCKET=my-unique-tfstate-111111111111 TABLE=my-tflock bash scripts/bootstrap-state-backend.sh
set -euo pipefail
REGION="${REGION:-us-east-1}"
BUCKET="${BUCKET:?Set BUCKET to a globally unique name}"
TABLE="${TABLE:-tf-lock}"
aws s3api create-bucket --bucket "$BUCKET" --region "$REGION" $([ "$REGION" != us-east-1 ] && echo "--create-bucket-configuration LocationConstraint=$REGION")
aws s3api put-bucket-versioning --bucket "$BUCKET" --versioning-configuration Status=Enabled
aws s3api put-bucket-encryption --bucket "$BUCKET" --server-side-encryption-configuration '{"Rules":[{"ApplyServerSideEncryptionByDefault":{"SSEAlgorithm":"AES256"}}]}'
aws s3api put-public-access-block --bucket "$BUCKET" --public-access-block-configuration BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true
aws dynamodb create-table --table-name "$TABLE" --attribute-definitions AttributeName=LockID,AttributeType=S --key-schema AttributeName=LockID,KeyType=HASH --billing-mode PAY_PER_REQUEST --region "$REGION" || true
echo "Update terraform/environments/*/backend.tf with bucket=$BUCKET table=$TABLE (locally, never commit real names if sensitive)."
