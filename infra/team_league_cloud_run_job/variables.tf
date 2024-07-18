variable "project_id" {
  description = "Project ID, used to enforce providing a project id."
  type        = string
}

variable "location" {
  description = "Location."
  type        = string
}

variable "job_name" {
  description = "Cloud Run job name."
  type        = string
}

variable "repo_name" {
  description = "Artifact Registry Repo Name."
  type        = string
}

variable "image_tag" {
  description = "Image Tag for the Cloud Run job."
  type        = string
}

variable "service_account" {
  description = "Service Account for the job and the Workflow."
  type        = string
}

variable "input_bucket" {
  description = "Input Bucket containing the input object."
  type        = string
}

variable "input_object" {
  description = "Input object to read."
  type        = string
}

variable "output_dataset" {
  description = "BigQuery Output Dataset."
  type        = string
}

variable "output_table" {
  description = "BigQuery Output table."
  type        = string
}

variable "scheduler_name" {
  description = "Scheduler Name."
  type        = string
}

variable "scheduler_cron" {
  description = "Scheduler Cron."
  type        = string
}