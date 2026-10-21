variable "instances" {
  description = "Map of instances to create. The key is used as the instance name."
  type = map(object({
    instance_type = string
    volume_type   = string
    volume_size   = number
    iops          = optional(number) # only needed for io1 / io2 (and optional for gp3)
    key_name      = string
    protected     = optional(bool, false) # true = prevent_destroy is turned on
  }))

  # io1 and io2 volumes will fail without an iops value, so check it early
  validation {
    condition = alltrue([
      for inst in values(var.instances) :
      contains(["io1", "io2"], inst.volume_type) ? inst.iops != null : true
    ])
    error_message = "Instances using io1 or io2 volumes must have an iops value."
  }
}

variable "environment" {
  description = "Environment name used in tags"
  type        = string
}

variable "owner" {
  description = "Owner name used in tags"
  type        = string
}

variable "subnet_id" {
  description = "Subnet to launch the instances in. If null, the default subnet is used."
  type        = string
  default     = null
}
