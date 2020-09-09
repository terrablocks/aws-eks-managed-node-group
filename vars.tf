variable "cluster_name" {}

variable "node_group_name" {
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

variable "instance_type" {
  default = "t3.medium"
}

variable "disk_size" {
  default = 20
}

variable "labels" {
  type = map

  default = {}
}

variable "ami_type" {
  default = "AL2_x86_64"
}

variable "ssh_key_pair" {
  default = ""
}

variable "sg_ids" {
  type    = list
  default = []
}
