# Latest Amazon Linux 2023 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

# lifecycle blocks only accept fixed values, so prevent_destroy can't be set
# per instance from a variable. To get around that, split the map in two:
# protected instances go in one resource block, the rest go in the other.
locals {
  protected_instances = { for name, inst in var.instances : name => inst if inst.protected }
  normal_instances    = { for name, inst in var.instances : name => inst if !inst.protected }
}

# Normal instances
resource "aws_instance" "this" {
  for_each = local.normal_instances

  ami           = data.aws_ami.amazon_linux.id
  instance_type = each.value.instance_type
  key_name      = each.value.key_name
  subnet_id     = var.subnet_id

  root_block_device {
    volume_type           = each.value.volume_type
    volume_size           = each.value.volume_size
    iops                  = each.value.iops
    encrypted             = true
    delete_on_termination = true
  }

  tags = {
    Name        = each.key
    Environment = var.environment
    Owner       = var.owner
  }
}

# Protected instances - terraform will refuse to destroy these
resource "aws_instance" "protected" {
  for_each = local.protected_instances

  ami           = data.aws_ami.amazon_linux.id
  instance_type = each.value.instance_type
  key_name      = each.value.key_name
  subnet_id     = var.subnet_id

  root_block_device {
    volume_type           = each.value.volume_type
    volume_size           = each.value.volume_size
    iops                  = each.value.iops
    encrypted             = true
    delete_on_termination = true
  }

  tags = {
    Name        = each.key
    Environment = var.environment
    Owner       = var.owner
  }

  lifecycle {
    prevent_destroy = true
  }
}
