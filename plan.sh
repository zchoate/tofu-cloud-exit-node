#!/bin/bash

# Load environment variables
if [ -f .env ]; then
  set -a
  source .env
  set +a
fi

# Set AWS credentials for Digital Ocean Spaces
export AWS_ACCESS_KEY_ID="${DO_BUCKET_ACCESS_KEY}"
export AWS_SECRET_ACCESS_KEY="${DO_BUCKET_SECRET_KEY}"
export AWS_DEFAULT_REGION="${DO_BUCKET_REGION}"

tofu init \
  -backend-config="bucket=${DO_BUCKET_NAME}" \
  -backend-config="key=tofu-cloud-exit-node/terraform.tfstate" \
  -backend-config="region=${DO_BUCKET_REGION}" \
  -backend-config="endpoint=${DO_BUCKET_ENDPOINT}" \
  -backend-config="skip_credentials_validation=true" \
  -backend-config="skip_metadata_api_check=true" \
  -backend-config="skip_region_validation=true" \
  -backend-config="skip_requesting_account_id=true"

tofu plan