output "instance_ids" {
  description = "Instance name => instance ID"
  value       = module.ec2.instance_ids
}

output "private_ips" {
  description = "Instance name => private IP"
  value       = module.ec2.private_ips
}
