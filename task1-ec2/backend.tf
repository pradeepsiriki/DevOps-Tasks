# Remote state in S3 with DynamoDB locking (Task 2).
# The bucket and table are created first from the task2-remote-state folder.
# Backend blocks can't use variables, so the values are written directly.
terraform {
  backend "s3" {
    bucket         = "pradeep-tfstate-379959319021""
    key            = "task1-ec2/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}
