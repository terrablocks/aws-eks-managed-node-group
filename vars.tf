variable "eks_cluster_name" {}

variable "subnet_ids" {}

variable "desired_size" {
  default = 2
}

variable "max_size" {
  default = 2
}

variable "min_size" {
  default = 2
}

variable "instance_type" {
  default = "t3.medium"
}

variable "disk_size" {
  default = 20
}

variable "ami_type" {
  default = "AL2_x86_64"
}

variable "enable_remote_access" {
  default = false
}

variable "ssh_key_pair" {
  default = ""
}

variable "sg_ids" {
  type    = list
  default = []
}
