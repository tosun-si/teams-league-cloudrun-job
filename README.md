# teams-league-cloudrun-job

Project showing a complete use case with a Cloud Run Job written with a Python module and multiple files.

The video in English :

https://youtu.be/b6eVoGMPQZc

The video in French :

https://youtu.be/3pkuYxEiHC4

## Build the container for Cloud Run Job with Cloud Build

Update `GCloud CLI` :

```bash
gcloud components update
```

Execute the following commands :

```bash
export PROJECT_ID=$(gcloud config get-value project)
export JOB_NAME=teams-league-job

gcloud builds submit --tag europe-west1-docker.pkg.dev/${PROJECT_ID}/internal-images/${JOB_NAME}:latest ./team_league/job
```

## Deploy the container image to Cloud Run

```bash
gcloud run deploy ${JOB_NAME} \
  --image europe-west1-docker.pkg.dev/${PROJECT_ID}/internal-images/${JOB_NAME}:latest \
  --region=${LOCATION}
```

Build and Publish Cloud Run Docker image:

```bash
gcloud builds submit \
    --project=$PROJECT_ID \
    --region=$LOCATION \
    --config build-cloud-run-job-docker-image.yaml \
    --substitutions _REPO_NAME="$REPO_NAME",_JOB_NAME="$JOB_NAME",_IMAGE_TAG="$IMAGE_TAG" \
    --verbosity="debug" .
```

Deploy the Cloud Run job and scheduler with gcloud commands:

```bash
gcloud builds submit \
    --project=$PROJECT_ID \
    --region=$LOCATION \
    --config deploy-cloud-run-job-with-gcloud.yaml \
    --substitutions _SERVICE_ACCOUNT="$SERVICE_ACCOUNT",_REPO_NAME="$REPO_NAME",_JOB_NAME="$JOB_NAME",_IMAGE_TAG="$IMAGE_TAG",_OUTPUT_DATASET="$OUTPUT_DATASET",_OUTPUT_TABLE="$OUTPUT_TABLE",_INPUT_BUCKET="$INPUT_BUCKET",_INPUT_OBJECT="$INPUT_OBJECT",_SCHEDULER_NAME="$SCHEDULER_NAME",_SCHEDULER_CRON="$SCHEDULER_CRON" \
    --verbosity="debug" .
```

Deploy the Cloud Run job and scheduler with Terraform:

Plan:

```bash
gcloud builds submit \
    --project=$PROJECT_ID \
    --region=$LOCATION \
    --config deploy-cloud-run-job-with-terraform-plan.yaml \
    --substitutions _TF_STATE_BUCKET="$TF_STATE_BUCKET",_TF_STATE_PREFIX="$TF_STATE_PREFIX",_SERVICE_ACCOUNT="$SERVICE_ACCOUNT",_REPO_NAME="$REPO_NAME",_JOB_NAME="$JOB_NAME",_IMAGE_TAG="$IMAGE_TAG",_OUTPUT_DATASET="$OUTPUT_DATASET",_OUTPUT_TABLE="$OUTPUT_TABLE",_INPUT_BUCKET="$INPUT_BUCKET",_INPUT_OBJECT="$INPUT_OBJECT",_SCHEDULER_NAME="$SCHEDULER_NAME",_SCHEDULER_CRON="$SCHEDULER_CRON" \
    --verbosity="debug" .
```

Apply:

```bash
gcloud builds submit \
    --project=$PROJECT_ID \
    --region=$LOCATION \
    --config deploy-cloud-run-job-with-terraform-apply.yaml \
    --substitutions _TF_STATE_BUCKET="$TF_STATE_BUCKET",_TF_STATE_PREFIX="$TF_STATE_PREFIX",_SERVICE_ACCOUNT="$SERVICE_ACCOUNT",_REPO_NAME="$REPO_NAME",_JOB_NAME="$JOB_NAME",_IMAGE_TAG="$IMAGE_TAG",_OUTPUT_DATASET="$OUTPUT_DATASET",_OUTPUT_TABLE="$OUTPUT_TABLE",_INPUT_BUCKET="$INPUT_BUCKET",_INPUT_OBJECT="$INPUT_OBJECT",_SCHEDULER_NAME="$SCHEDULER_NAME",_SCHEDULER_CRON="$SCHEDULER_CRON" \
    --verbosity="debug" .
```

Destroy:

```bash
gcloud builds submit \
    --project=$PROJECT_ID \
    --region=$LOCATION \
    --config deploy-cloud-run-job-with-terraform-destroy.yaml \
    --substitutions _TF_STATE_BUCKET="$TF_STATE_BUCKET",_TF_STATE_PREFIX="$TF_STATE_PREFIX",_SERVICE_ACCOUNT="$SERVICE_ACCOUNT",_REPO_NAME="$REPO_NAME",_JOB_NAME="$JOB_NAME",_IMAGE_TAG="$IMAGE_TAG",_OUTPUT_DATASET="$OUTPUT_DATASET",_OUTPUT_TABLE="$OUTPUT_TABLE",_INPUT_BUCKET="$INPUT_BUCKET",_INPUT_OBJECT="$INPUT_OBJECT",_SCHEDULER_NAME="$SCHEDULER_NAME",_SCHEDULER_CRON="$SCHEDULER_CRON" \
    --verbosity="debug" .
```

Execution with a Cloud Build manual trigger :

```bash
gcloud beta builds triggers create manual \
    --project=$PROJECT_ID \
    --region=$LOCATION \
    --name="deploy-cloud-run-job-team-league" \
    --repo="https://github.com/tosun-si/teams-league-cloudrun-job" \
    --repo-type="GITHUB" \
    --branch="main" \
    --build-config="deploy-cloud-run-job-with-gcloud.yaml" \
    --substitutions _SERVICE_ACCOUNT="$SERVICE_ACCOUNT",_REPO_NAME="$REPO_NAME",_JOB_NAME="$JOB_NAME",_IMAGE_TAG="$IMAGE_TAG",_OUTPUT_DATASET="$OUTPUT_DATASET",_OUTPUT_TABLE="$OUTPUT_TABLE",_INPUT_BUCKET="$INPUT_BUCKET",_INPUT_OBJECT="$INPUT_OBJECT" \
    --verbosity="debug"
```