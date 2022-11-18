locals {
  topic                            = "${var.owner}-cloud-function-topic"
  subscription                     = "${local.topic}-sub"
  ts                               = formatdate("YYYYMMDDhhmmss", timestamp())
  test_file                        = "${var.owner}-${local.ts}.txt"
  labels                           = {
    owner = var.owner
  }
}

data "archive_file" "source" {
  type        = "zip"
  source_dir  = "."
  excludes = [ ".idea", "functions-hello-world.iml", "target", "clound-function.tf", ".terraform", "terraform.tfstate", "terraform.tfstate.backup", ".terraform.tfstate.lock.info"]
  output_path = "/tmp/${var.owner}-cloud-function-java11.zip"
}

resource "google_storage_bucket" "bucket" {
  project  = var.project
  name     = "${var.owner}-cloud-function-bucket"
  location = "US"
  force_destroy = true
}

resource "google_storage_bucket_object" "archive" {
  content_type = "application/zip"
  name         = "src-${data.archive_file.source.output_md5}.zip"
  bucket       = google_storage_bucket.bucket.name
  source       = data.archive_file.source.output_path
}

resource "google_cloudfunctions_function" "my_http_function" {
  project     = var.project
  name        = "${var.owner}-http-cloud-function-java11"
  runtime     = "java11"
  region      = var.region
  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket.bucket.name
  source_archive_object = google_storage_bucket_object.archive.name
  trigger_http          = true
  entry_point           = "functions.MyHttpFunction"
}

# IAM entry for all users to invoke the function
//resource "google_cloudfunctions_function_iam_member" "invoker" {
//  project        = google_cloudfunctions_function.function.project
//  region         = google_cloudfunctions_function.function.region
//  cloud_function = google_cloudfunctions_function.function.name
//
//  role   = "roles/cloudfunctions.invoker"
//  member = "allUsers"
//}


resource "google_pubsub_topic" "my_topic" {
  project    = var.project
  name       = local.topic
  labels     = local.labels
}

resource "google_cloudfunctions_function" "my_pubsub_function" {
  project     = var.project
  name        = "${var.owner}-pubsub-cloud-function-java11"
  runtime     = "java11"
  region      = var.region
  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket.bucket.name
  source_archive_object = google_storage_bucket_object.archive.name
  event_trigger {
    event_type = "google.pubsub.topic.publish"
    resource   = google_pubsub_topic.my_topic.id  # projects/{{project}}/topics/{{name}}
  }
  entry_point           = "functions.MyPubSubMessageFunction"
}

resource "google_cloudfunctions_function" "my_gcs_function" {
  project     = var.project
  name        = "${var.owner}-gcs-cloud-function-java11"
  runtime     = "java11"
  region      = var.region
  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket.bucket.name
  source_archive_object = google_storage_bucket_object.archive.name
  event_trigger {
    event_type = "google.storage.object.finalize"
    resource   = google_storage_bucket.bucket.id
  }
  entry_point           = "functions.MyStorageObjectFunction"
}

resource "null_resource" "test_pubsub_cloud_function" {
  depends_on = [ google_cloudfunctions_function.my_pubsub_function ]
  triggers = { always_run = local.ts }
  provisioner "local-exec" {
    command = <<EOT
      gcloud pubsub topics publish ${google_pubsub_topic.my_topic.name} --message="${var.owner} ${local.ts}" --attribute="myAttrA=YYY,myAttrB=XXX"
    EOT
  }
}

resource "null_resource" "test_gcs_cloud_function" {
  depends_on = [ google_cloudfunctions_function.my_gcs_function ]
  triggers = { always_run = local.ts }
  provisioner "local-exec" {
    command = <<EOT
      echo $(date) >> ${local.test_file} && gsutil cp ${local.test_file} "gs://${google_storage_bucket.bucket.name}/" && rm "${local.test_file}"
    EOT
  }
}
