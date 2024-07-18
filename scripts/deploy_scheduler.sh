#!/usr/bin/env bash

set -e
set -o pipefail
set -u

echo "############# Deploying the Scheduler $SCHEDULER_NAME for the Cloud Run Job $JOB_NAME"

gcloud scheduler jobs create http "$SCHEDULER_NAME" \
  --location "$LOCATION" \
  --schedule="$SCHEDULER_CRON" \
  --description="Scheduler for the Cloud Run Job" \
  --uri="https://$LOCATION-run.googleapis.com/apis/run.googleapis.com/v1/namespaces/$PROJECT_ID/jobs/$JOB_NAME:run" \
  --http-method POST \
  --oauth-service-account-email "$SERVICE_ACCOUNT"
