variable "cluster_name" {}

variable "ng_name" {
  default = ""
}

variable "create_ng_role" {
  default = true
}

variable "ng_role_arn" {
  default = ""
}

variable "subnet_ids" {}

variable "launch_template_id" {
  default = ""
}

variable "launch_template_name" {
  default = ""
}

variable "launch_template_version" {
  default = "$Latest"
}

variable "desired_size" {
  default = 2
}

variable "max_size" {
  default = 4
}

variable "min_size" {
  default = 2
}

variable "capacity_type" {
  default = "ON_DEMAND"
}

variable "instance_type" {
  default = "t3.medium"
}

variable "disk_size" {
  default = 20
}

variable "labels" {
  type = map(any)

  default = {}
}

variable "ami_type" {
  default = "AL2_x86_64"
}

variable "ssh_key_pair" {
  default = ""
}

variable "sg_ids" {
  type    = list(any)
  default = []
}
