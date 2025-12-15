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

tofu apply --auto-approve
