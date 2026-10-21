variable "region" {
  type    = string
  default = "ap-south-1"
}

# Users for group2 (console + CLI)
variable "console_users" {
  type    = list(string)
  default = ["alice", "bob"]
}

# The one bucket in Account B that roleC can access
variable "bucket_name" {
  type    = string
  default = "pradeep-accountb-data-379959319021"
}