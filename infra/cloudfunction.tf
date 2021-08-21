data "archive_file" "archivo_zip" {
  type        = "zip"
  source_dir  = "../code/"
  output_path = "ILoveMkdev.zip"
}

# Store ziped code in the bucket
resource "google_storage_bucket_object" "bucket" {
  name   = "function.${data.archive_file.archivo_zip.output_base64sha256}.zip"
  bucket = "function_github"
  source = data.archive_file.archivo_zip.output_path
}

resource "google_cloudfunctions_function" "ILoveMkdev" {
  name                  = "ILoveMkdev"
  trigger_http          = true
  source_archive_bucket = "function_github"
  source_archive_object = google_storage_bucket_object.bucket.name
  runtime               = "python38"
  entry_point           = "http_handler"
}

resource "google_cloudfunctions_function_iam_member" "invoker" {
  project        = "mkdevyoutube"
  region         = "europe-west1"
  cloud_function = google_cloudfunctions_function.ILoveMkdev.name

  role   = "roles/cloudfunctions.invoker"
  member = "allUsers"
}

output "url" {
  value       = google_cloudfunctions_function.ILoveMkdev.https_trigger_url
  description = "URL con el valor de https_trigger_url"
}
