data "archive_file" "fake_bootstrap" {
  type                    = "zip"
  source_content          = "foo"
  source_content_filename = "bootstrap"
  output_path             = "./${var.name}/bootstrap.zip"
}

// need this so lambda will create, but TF should ignore all changes since we'll be uploading new application code with each deploy
resource "aws_s3_object" "bootstrapping_the_bootstrap" {
  bucket = var.artifact_bucket
  key    = "${var.name}/bootstrap.zip"
  source = data.archive_file.fake_bootstrap.output_path

  lifecycle {
    ignore_changes = all
  }
}
