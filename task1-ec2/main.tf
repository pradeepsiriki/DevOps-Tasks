# All 5 instances are defined here in one map.
# Each one has its own instance type, volume type, volume size and key pair.
# Note: the key pairs (key-web, key-app ...) must already exist in the region.
module "ec2" {
  source = "./modules/ec2"

  environment = var.environment
  owner       = var.owner

  instances = {
    web-server = {
      instance_type = "t3.micro"
      volume_type   = "gp3"
      volume_size   = 10
      key_name      = "key-web"
    }

    app-server = {
      instance_type = "t3.small"
      volume_type   = "gp2"
      volume_size   = 20
      key_name      = "key-app"
    }

    # database server - uses io2 for high IOPS, protected from deletion
    db-server = {
      instance_type = "m7i-flex.large"
      volume_type   = "gp3"        # TEMP - was io2
      volume_size   = 12
      # iops        = 100          # TEMP - commented out
      key_name      = "key-db"
      protected     = true
    }

    cache-server = {
      instance_type = "t8i.small"
      volume_type   = "gp3"        # TEMP - was io1
      volume_size   = 14
      # iops        = 100          # TEMP - commented out
      key_name      = "key-cache"
    }
    bastion = {
      instance_type = "t8i.micro"
      volume_type   = "standard"
      volume_size   = 8
      key_name      = "key-bastion"
    }
  }
}
