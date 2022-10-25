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
}

resource "google_storage_bucket_object" "archive" {
  content_type = "application/zip"
  name         = "src-${data.archive_file.source.output_md5}.zip"
  bucket       = google_storage_bucket.bucket.name
  source       = data.archive_file.source.output_path
}

resource "google_cloudfunctions_function" "helloworld" {
  project     = var.project
  name        = "${var.owner}-cloud-function-java11"
  runtime     = "java11"
  region      = var.region
  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket.bucket.name
  source_archive_object = google_storage_bucket_object.archive.name
  trigger_http          = true
  entry_point           = "functions.HelloWorld"
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