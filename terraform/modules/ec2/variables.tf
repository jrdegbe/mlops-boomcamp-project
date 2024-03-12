variable "instance_type" {
  # See https://aws.amazon.com/ec2/instance-types/
  description = "Amazon EC2 instance types"
  type        = string
  default     = "t2.small"
  # default = "t2.xlarge"
  # default = "g4dn.xlarge" 
  # default = "g4dn.2xlarge"
}

variable "instance_name" {
  description = "Name of the instance"
  type = string
  default = "mlops-boomcamp-ec2"
}

variable "instance_volume_size" {
  description = "Size of the volume in gibibytes (GiB)"
  type        = number
  default     = 10
}

variable "key_name" {
  description = "Name of the pem key"
  type        = string
  default     = "razer"
}

variable "ingress_cidr_blocks" {
  # Search on Google "what is my ip".
  description = "List of IPv4 CIDR ranges to use on all ingress rules"
  type        = list(string)
  default     = ["24.201.179.109/32"]
}
