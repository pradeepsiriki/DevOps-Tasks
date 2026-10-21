@pradeepsiriki ➜ /workspaces/DevOps-Tasks/task1-ec2 (main) $ terraform destroy
module.ec2.data.aws_ami.amazon_linux: Reading...
module.ec2.data.aws_ami.amazon_linux: Read complete after 0s [id=ami-00d7727679cec655c]
module.ec2.aws_instance.this["bastion"]: Refreshing state... [id=i-09545d75357c44b04]
module.ec2.aws_instance.protected["db-server"]: Refreshing state... [id=i-0a70d55932b1cfb1a]
module.ec2.aws_instance.this["cache-server"]: Refreshing state... [id=i-0af1034aac5f022ec]
module.ec2.aws_instance.this["web-server"]: Refreshing state... [id=i-088d5dc90411f05a4]
module.ec2.aws_instance.this["app-server"]: Refreshing state... [id=i-04fdcc6c53da00771]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  - destroy

Terraform planned the following actions, but then encountered a problem:

  # module.ec2.aws_instance.protected["db-server"] will be destroyed
  - resource "aws_instance" "protected" {
      - ami                                  = "ami-00d7727679cec655c" -> null
      - arn                                  = "arn:aws:ec2:ap-south-1:379959319021:instance/i-0a70d55932b1cfb1a" -> null
      - associate_public_ip_address          = true -> null
      - availability_zone                    = "ap-south-1a" -> null
      - cpu_core_count                       = 1 -> null
      - cpu_threads_per_core                 = 2 -> null
      - disable_api_stop                     = false -> null
      - disable_api_termination              = false -> null
      - ebs_optimized                        = false -> null
      - get_password_data                    = false -> null
      - hibernation                          = false -> null
      - id                                   = "i-0a70d55932b1cfb1a" -> null
      - instance_initiated_shutdown_behavior = "stop" -> null
      - instance_state                       = "running" -> null
      - instance_type                        = "m7i-flex.large" -> null
      - ipv6_address_count                   = 0 -> null
      - ipv6_addresses                       = [] -> null
      - key_name                             = "key-db" -> null
      - monitoring                           = false -> null
      - placement_partition_number           = 0 -> null
      - primary_network_interface_id         = "eni-02dcbcb0a2e28c930" -> null
      - private_dns                          = "ip-172-31-38-81.ap-south-1.compute.internal" -> null
      - private_ip                           = "172.31.38.81" -> null
      - public_dns                           = "ec2-13-207-40-100.ap-south-1.compute.amazonaws.com" -> null
      - public_ip                            = "13.207.40.100" -> null
      - secondary_private_ips                = [] -> null
      - security_groups                      = [
          - "default",
        ] -> null
      - source_dest_check                    = true -> null
      - subnet_id                            = "subnet-017c4cad0a11df7ba" -> null
      - tags                                 = {
          - "Environment" = "dev"
          - "Name"        = "db-server"
          - "Owner"       = "pradeepsiriki"
        } -> null
      - tags_all                             = {
          - "Environment" = "dev"
          - "Name"        = "db-server"
          - "Owner"       = "pradeepsiriki"
        } -> null
      - tenancy                              = "default" -> null
      - user_data_replace_on_change          = false -> null
      - vpc_security_group_ids               = [
          - "sg-0dd08411a2fcaec32",
        ] -> null
        # (7 unchanged attributes hidden)

      - capacity_reservation_specification {
          - capacity_reservation_preference = "open" -> null
        }

      - cpu_options {
          - core_count       = 1 -> null
          - threads_per_core = 2 -> null
            # (1 unchanged attribute hidden)
        }

      - enclave_options {
          - enabled = false -> null
        }

      - maintenance_options {
          - auto_recovery = "default" -> null
        }

      - metadata_options {
          - http_endpoint               = "enabled" -> null
          - http_protocol_ipv6          = "disabled" -> null
          - http_put_response_hop_limit = 2 -> null
          - http_tokens                 = "required" -> null
          - instance_metadata_tags      = "disabled" -> null
        }

      - private_dns_name_options {
          - enable_resource_name_dns_a_record    = false -> null
          - enable_resource_name_dns_aaaa_record = false -> null
          - hostname_type                        = "ip-name" -> null
        }

      - root_block_device {
          - delete_on_termination = true -> null
          - device_name           = "/dev/xvda" -> null
          - encrypted             = true -> null
          - iops                  = 3000 -> null
          - kms_key_id            = "arn:aws:kms:ap-south-1:379959319021:key/dc6c1d92-c2d5-40ac-9ab1-b822c3a9b69e" -> null
          - tags                  = {} -> null
          - tags_all              = {} -> null
          - throughput            = 125 -> null
          - volume_id             = "vol-098c56e638770ae77" -> null
          - volume_size           = 12 -> null
          - volume_type           = "gp3" -> null
        }
    }

  # module.ec2.aws_instance.this["app-server"] will be destroyed
  - resource "aws_instance" "this" {
      - ami                                  = "ami-00d7727679cec655c" -> null
      - arn                                  = "arn:aws:ec2:ap-south-1:379959319021:instance/i-04fdcc6c53da00771" -> null
      - associate_public_ip_address          = true -> null
      - availability_zone                    = "ap-south-1b" -> null
      - cpu_core_count                       = 1 -> null
      - cpu_threads_per_core                 = 2 -> null
      - disable_api_stop                     = false -> null
      - disable_api_termination              = false -> null
      - ebs_optimized                        = false -> null
      - get_password_data                    = false -> null
      - hibernation                          = false -> null
      - id                                   = "i-04fdcc6c53da00771" -> null
      - instance_initiated_shutdown_behavior = "stop" -> null
      - instance_state                       = "running" -> null
      - instance_type                        = "t3.small" -> null
      - ipv6_address_count                   = 0 -> null
      - ipv6_addresses                       = [] -> null
      - key_name                             = "key-app" -> null
      - monitoring                           = false -> null
      - placement_partition_number           = 0 -> null
      - primary_network_interface_id         = "eni-0d6318965f0b2ed24" -> null
      - private_dns                          = "ip-172-31-5-229.ap-south-1.compute.internal" -> null
      - private_ip                           = "172.31.5.229" -> null
      - public_dns                           = "ec2-65-1-91-148.ap-south-1.compute.amazonaws.com" -> null
      - public_ip                            = "65.1.91.148" -> null
      - secondary_private_ips                = [] -> null
      - security_groups                      = [
          - "default",
        ] -> null
      - source_dest_check                    = true -> null
      - subnet_id                            = "subnet-0d9e440187801197f" -> null
      - tags                                 = {
          - "Environment" = "dev"
          - "Name"        = "app-server"
          - "Owner"       = "pradeepsiriki"
        } -> null
      - tags_all                             = {
          - "Environment" = "dev"
          - "Name"        = "app-server"
          - "Owner"       = "pradeepsiriki"
        } -> null
      - tenancy                              = "default" -> null
      - user_data_replace_on_change          = false -> null
      - vpc_security_group_ids               = [
          - "sg-0dd08411a2fcaec32",
        ] -> null
        # (7 unchanged attributes hidden)

      - capacity_reservation_specification {
          - capacity_reservation_preference = "open" -> null
        }

      - cpu_options {
          - core_count       = 1 -> null
          - threads_per_core = 2 -> null
            # (1 unchanged attribute hidden)
        }

      - credit_specification {
          - cpu_credits = "unlimited" -> null
        }

      - enclave_options {
          - enabled = false -> null
        }

      - maintenance_options {
          - auto_recovery = "default" -> null
        }

      - metadata_options {
          - http_endpoint               = "enabled" -> null
          - http_protocol_ipv6          = "disabled" -> null
          - http_put_response_hop_limit = 2 -> null
          - http_tokens                 = "required" -> null
          - instance_metadata_tags      = "disabled" -> null
        }

      - private_dns_name_options {
          - enable_resource_name_dns_a_record    = false -> null
          - enable_resource_name_dns_aaaa_record = false -> null
          - hostname_type                        = "ip-name" -> null
        }

      - root_block_device {
          - delete_on_termination = true -> null
          - device_name           = "/dev/xvda" -> null
          - encrypted             = true -> null
          - iops                  = 100 -> null
          - kms_key_id            = "arn:aws:kms:ap-south-1:379959319021:key/dc6c1d92-c2d5-40ac-9ab1-b822c3a9b69e" -> null
          - tags                  = {} -> null
          - tags_all              = {} -> null
          - throughput            = 0 -> null
          - volume_id             = "vol-08fad8430ca343104" -> null
          - volume_size           = 20 -> null
          - volume_type           = "gp2" -> null
        }
    }

  # module.ec2.aws_instance.this["bastion"] will be destroyed
  - resource "aws_instance" "this" {
      - ami                                  = "ami-00d7727679cec655c" -> null
      - arn                                  = "arn:aws:ec2:ap-south-1:379959319021:instance/i-09545d75357c44b04" -> null
      - associate_public_ip_address          = true -> null
      - availability_zone                    = "ap-south-1a" -> null
      - cpu_core_count                       = 1 -> null
      - cpu_threads_per_core                 = 2 -> null
      - disable_api_stop                     = false -> null
      - disable_api_termination              = false -> null
      - ebs_optimized                        = false -> null
      - get_password_data                    = false -> null
      - hibernation                          = false -> null
      - id                                   = "i-09545d75357c44b04" -> null
      - instance_initiated_shutdown_behavior = "stop" -> null
      - instance_state                       = "running" -> null
      - instance_type                        = "t8i.micro" -> null
      - ipv6_address_count                   = 0 -> null
      - ipv6_addresses                       = [] -> null
      - key_name                             = "key-bastion" -> null
      - monitoring                           = false -> null
      - placement_partition_number           = 0 -> null
      - primary_network_interface_id         = "eni-07f6de9d06c850cbd" -> null
      - private_dns                          = "ip-172-31-39-67.ap-south-1.compute.internal" -> null
      - private_ip                           = "172.31.39.67" -> null
      - public_dns                           = "ec2-13-233-238-97.ap-south-1.compute.amazonaws.com" -> null
      - public_ip                            = "13.233.238.97" -> null
      - secondary_private_ips                = [] -> null
      - security_groups                      = [
          - "default",
        ] -> null
      - source_dest_check                    = true -> null
      - subnet_id                            = "subnet-017c4cad0a11df7ba" -> null
      - tags                                 = {
          - "Environment" = "dev"
          - "Name"        = "bastion"
          - "Owner"       = "pradeepsiriki"
        } -> null
      - tags_all                             = {
          - "Environment" = "dev"
          - "Name"        = "bastion"
          - "Owner"       = "pradeepsiriki"
        } -> null
      - tenancy                              = "default" -> null
      - user_data_replace_on_change          = false -> null
      - vpc_security_group_ids               = [
          - "sg-0dd08411a2fcaec32",
        ] -> null
        # (7 unchanged attributes hidden)

      - capacity_reservation_specification {
          - capacity_reservation_preference = "open" -> null
        }

      - cpu_options {
          - core_count       = 1 -> null
          - threads_per_core = 2 -> null
            # (1 unchanged attribute hidden)
        }

      - credit_specification {
          - cpu_credits = "unlimited" -> null
        }

      - enclave_options {
          - enabled = false -> null
        }

      - maintenance_options {
          - auto_recovery = "default" -> null
        }

      - metadata_options {
          - http_endpoint               = "enabled" -> null
          - http_protocol_ipv6          = "disabled" -> null
          - http_put_response_hop_limit = 2 -> null
          - http_tokens                 = "required" -> null
          - instance_metadata_tags      = "disabled" -> null
        }

      - private_dns_name_options {
          - enable_resource_name_dns_a_record    = false -> null
          - enable_resource_name_dns_aaaa_record = false -> null
          - hostname_type                        = "ip-name" -> null
        }

      - root_block_device {
          - delete_on_termination = true -> null
          - device_name           = "/dev/xvda" -> null
          - encrypted             = true -> null
          - iops                  = 0 -> null
          - kms_key_id            = "arn:aws:kms:ap-south-1:379959319021:key/dc6c1d92-c2d5-40ac-9ab1-b822c3a9b69e" -> null
          - tags                  = {} -> null
          - tags_all              = {} -> null
          - throughput            = 0 -> null
          - volume_id             = "vol-0a8aa7f6e88f5668d" -> null
          - volume_size           = 8 -> null
          - volume_type           = "standard" -> null
        }
    }

  # module.ec2.aws_instance.this["cache-server"] will be destroyed
  - resource "aws_instance" "this" {
      - ami                                  = "ami-00d7727679cec655c" -> null
      - arn                                  = "arn:aws:ec2:ap-south-1:379959319021:instance/i-0af1034aac5f022ec" -> null
      - associate_public_ip_address          = true -> null
      - availability_zone                    = "ap-south-1c" -> null
      - cpu_core_count                       = 1 -> null
      - cpu_threads_per_core                 = 2 -> null
      - disable_api_stop                     = false -> null
      - disable_api_termination              = false -> null
      - ebs_optimized                        = false -> null
      - get_password_data                    = false -> null
      - hibernation                          = false -> null
      - id                                   = "i-0af1034aac5f022ec" -> null
      - instance_initiated_shutdown_behavior = "stop" -> null
      - instance_state                       = "running" -> null
      - instance_type                        = "t8i.small" -> null
      - ipv6_address_count                   = 0 -> null
      - ipv6_addresses                       = [] -> null
      - key_name                             = "key-cache" -> null
      - monitoring                           = false -> null
      - placement_partition_number           = 0 -> null
      - primary_network_interface_id         = "eni-0d7deb38409c5a39d" -> null
      - private_dns                          = "ip-172-31-19-184.ap-south-1.compute.internal" -> null
      - private_ip                           = "172.31.19.184" -> null
      - public_dns                           = "ec2-3-110-229-160.ap-south-1.compute.amazonaws.com" -> null
      - public_ip                            = "3.110.229.160" -> null
      - secondary_private_ips                = [] -> null
      - security_groups                      = [
          - "default",
        ] -> null
      - source_dest_check                    = true -> null
      - subnet_id                            = "subnet-0e46008bce14519d2" -> null
      - tags                                 = {
          - "Environment" = "dev"
          - "Name"        = "cache-server"
          - "Owner"       = "pradeepsiriki"
        } -> null
      - tags_all                             = {
          - "Environment" = "dev"
          - "Name"        = "cache-server"
          - "Owner"       = "pradeepsiriki"
        } -> null
      - tenancy                              = "default" -> null
      - user_data_replace_on_change          = false -> null
      - vpc_security_group_ids               = [
          - "sg-0dd08411a2fcaec32",
        ] -> null
        # (7 unchanged attributes hidden)

      - capacity_reservation_specification {
          - capacity_reservation_preference = "open" -> null
        }

      - cpu_options {
          - core_count       = 1 -> null
          - threads_per_core = 2 -> null
            # (1 unchanged attribute hidden)
        }

      - credit_specification {
          - cpu_credits = "unlimited" -> null
        }

      - enclave_options {
          - enabled = false -> null
        }

      - maintenance_options {
          - auto_recovery = "default" -> null
        }

      - metadata_options {
          - http_endpoint               = "enabled" -> null
          - http_protocol_ipv6          = "disabled" -> null
          - http_put_response_hop_limit = 2 -> null
          - http_tokens                 = "required" -> null
          - instance_metadata_tags      = "disabled" -> null
        }

      - private_dns_name_options {
          - enable_resource_name_dns_a_record    = false -> null
          - enable_resource_name_dns_aaaa_record = false -> null
          - hostname_type                        = "ip-name" -> null
        }

      - root_block_device {
          - delete_on_termination = true -> null
          - device_name           = "/dev/xvda" -> null
          - encrypted             = true -> null
          - iops                  = 3000 -> null
          - kms_key_id            = "arn:aws:kms:ap-south-1:379959319021:key/dc6c1d92-c2d5-40ac-9ab1-b822c3a9b69e" -> null
          - tags                  = {} -> null
          - tags_all              = {} -> null
          - throughput            = 125 -> null
          - volume_id             = "vol-0d98b68663327d8d8" -> null
          - volume_size           = 14 -> null
          - volume_type           = "gp3" -> null
        }
    }

  # module.ec2.aws_instance.this["web-server"] will be destroyed
  - resource "aws_instance" "this" {
      - ami                                  = "ami-00d7727679cec655c" -> null
      - arn                                  = "arn:aws:ec2:ap-south-1:379959319021:instance/i-088d5dc90411f05a4" -> null
      - associate_public_ip_address          = true -> null
      - availability_zone                    = "ap-south-1b" -> null
      - cpu_core_count                       = 1 -> null
      - cpu_threads_per_core                 = 2 -> null
      - disable_api_stop                     = false -> null
      - disable_api_termination              = false -> null
      - ebs_optimized                        = false -> null
      - get_password_data                    = false -> null
      - hibernation                          = false -> null
      - id                                   = "i-088d5dc90411f05a4" -> null
      - instance_initiated_shutdown_behavior = "stop" -> null
      - instance_state                       = "running" -> null
      - instance_type                        = "t3.micro" -> null
      - ipv6_address_count                   = 0 -> null
      - ipv6_addresses                       = [] -> null
      - key_name                             = "key-web" -> null
      - monitoring                           = false -> null
      - placement_partition_number           = 0 -> null
      - primary_network_interface_id         = "eni-0952addaa22c4f9ae" -> null
      - private_dns                          = "ip-172-31-7-132.ap-south-1.compute.internal" -> null
      - private_ip                           = "172.31.7.132" -> null
      - public_dns                           = "ec2-16-4-53-236.ap-south-1.compute.amazonaws.com" -> null
      - public_ip                            = "16.4.53.236" -> null
      - secondary_private_ips                = [] -> null
      - security_groups                      = [
          - "default",
        ] -> null
      - source_dest_check                    = true -> null
      - subnet_id                            = "subnet-0d9e440187801197f" -> null
      - tags                                 = {
          - "Environment" = "dev"
          - "Name"        = "web-server"
          - "Owner"       = "pradeepsiriki"
        } -> null
      - tags_all                             = {
          - "Environment" = "dev"
          - "Name"        = "web-server"
          - "Owner"       = "pradeepsiriki"
        } -> null
      - tenancy                              = "default" -> null
      - user_data_replace_on_change          = false -> null
      - vpc_security_group_ids               = [
          - "sg-0dd08411a2fcaec32",
        ] -> null
        # (7 unchanged attributes hidden)

      - capacity_reservation_specification {
          - capacity_reservation_preference = "open" -> null
        }

      - cpu_options {
          - core_count       = 1 -> null
          - threads_per_core = 2 -> null
            # (1 unchanged attribute hidden)
        }

      - credit_specification {
          - cpu_credits = "unlimited" -> null
        }

      - enclave_options {
          - enabled = false -> null
        }

      - maintenance_options {
          - auto_recovery = "default" -> null
        }

      - metadata_options {
          - http_endpoint               = "enabled" -> null
          - http_protocol_ipv6          = "disabled" -> null
          - http_put_response_hop_limit = 2 -> null
          - http_tokens                 = "required" -> null
          - instance_metadata_tags      = "disabled" -> null
        }

      - private_dns_name_options {
          - enable_resource_name_dns_a_record    = false -> null
          - enable_resource_name_dns_aaaa_record = false -> null
          - hostname_type                        = "ip-name" -> null
        }

      - root_block_device {
          - delete_on_termination = true -> null
          - device_name           = "/dev/xvda" -> null
          - encrypted             = true -> null
          - iops                  = 3000 -> null
          - kms_key_id            = "arn:aws:kms:ap-south-1:379959319021:key/dc6c1d92-c2d5-40ac-9ab1-b822c3a9b69e" -> null
          - tags                  = {} -> null
          - tags_all              = {} -> null
          - throughput            = 125 -> null
          - volume_id             = "vol-0e31608672dc4aaff" -> null
          - volume_size           = 10 -> null
          - volume_type           = "gp3" -> null
        }
    }

Plan: 0 to add, 0 to change, 5 to destroy.

Changes to Outputs:
  - instance_ids = {
      - app-server   = "i-04fdcc6c53da00771"
      - bastion      = "i-09545d75357c44b04"
      - cache-server = "i-0af1034aac5f022ec"
      - db-server    = "i-0a70d55932b1cfb1a"
      - web-server   = "i-088d5dc90411f05a4"
    } -> null
  - private_ips  = {
      - app-server   = "172.31.5.229"
      - bastion      = "172.31.39.67"
      - cache-server = "172.31.19.184"
      - db-server    = "172.31.38.81"
      - web-server   = "172.31.7.132"
    } -> null
╷
│ Error: Instance cannot be destroyed
│ 
│   on modules/ec2/main.tf line 45:
│   45: resource "aws_instance" "protected" {
│ 
│ Resource module.ec2.aws_instance.protected["db-server"] has lifecycle.prevent_destroy set, but the plan calls for this resource to be destroyed. To avoid this error and
│ continue with the plan, either disable lifecycle.prevent_destroy or reduce the scope of the plan using the -target option.
╵
@pradeepsiriki ➜ /workspaces/DevOps-Tasks/task1-ec2 (main) $ 