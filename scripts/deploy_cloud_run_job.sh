#!/usr/bin/env bash

set -e
set -o pipefail
set -u

echo "############# Deploying the Cloud Run Job $JOB_NAME"

gcloud run jobs deploy "$JOB_NAME" \
  --image "$LOCATION-docker.pkg.dev/$PROJECT_ID/$REPO_NAME/$JOB_NAME:$IMAGE_TAG" \
  --project="$PROJECT_ID" \
  --region="$LOCATION" \
  --service-account="$SERVICE_ACCOUNT" \
  --max-retries 3 \
  --set-env-vars PROJECT_ID="$PROJECT_ID" \
  --set-env-vars OUTPUT_DATASET="$OUTPUT_DATASET" \
  --set-env-vars OUTPUT_TABLE="$OUTPUT_TABLE" \
  --set-env-vars INPUT_BUCKET="$INPUT_BUCKET" \
  --set-env-vars INPUT_OBJECT="$INPUT_OBJECT"
