resource "google_cloud_run_v2_job" "team_league_cloud_run_job" {
  project  = var.project_id
  name     = local.job_name_with_terraform
  location = var.location

  template {
    template {
      max_retries = 3

      containers {
        image = "${var.location}-docker.pkg.dev/${var.project_id}/${var.repo_name}/${var.job_name}:${var.image_tag}"

        env {
          name  = "PROJECT_ID"
          value = var.project_id
        }
        env {
          name  = "INPUT_BUCKET"
          value = var.input_bucket
        }
        env {
          name  = "INPUT_OBJECT"
          value = var.input_object
        }
        env {
          name  = "OUTPUT_DATASET"
          value = var.output_dataset
        }
        env {
          name  = "OUTPUT_TABLE"
          value = var.output_table
        }
      }
    }
  }
}

resource "google_cloud_scheduler_job" "team_league_cloud_run_cron_job" {
  project          = var.project_id
  region           = var.location
  name             = local.scheduler_name_with_terraform
  description      = "Scheduler for the Cloud Run Job created with Terraform"
  schedule         = var.scheduler_cron
  attempt_deadline = "320s"

  retry_config {
    retry_count = 3
  }

  http_target {
    http_method = "POST"
    uri         = "https://${var.location}-run.googleapis.com/apis/run.googleapis.com/v1/namespaces/${var.project_id}/jobs/${local.job_name_with_terraform}:run"

    oauth_token {
      service_account_email = var.service_account
    }
  }

  depends_on = [
    google_cloud_run_v2_job.team_league_cloud_run_job
  ]
}