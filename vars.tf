variable "cluster_name" {
  type        = string
  description = "Name of EKS cluster"
}

variable "ng_name" {
  type        = string
  default     = ""
  description = "Name of EKS Node Group. Default: {cluster_name}-ng"
}

variable "create_ng_role" {
  type        = bool
  default     = true
  description = "Whether to create new IAM role for EKS nodes"
}

variable "ng_role_arn" {
  type        = string
  default     = ""
  description = "ARN of IAM role to associate with EKS nodes. Leave it blank to create IAM role with required permissions"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet ids to be used for launching EKS nodes"
}

variable "launch_template_id" {
  type        = string
  default     = ""
  description = "Launch template id to use for node group"
}

variable "launch_template_name" {
  type        = string
  default     = ""
  description = "Launch template name to use for node group"
}

variable "launch_template_version" {
  type        = string
  default     = "$Latest"
  description = "Launch template version to use for launching instances"
}

variable "desired_size" {
  type        = number
  default     = 2
  description = "Initial number of nodes to launch"
}

variable "max_size" {
  type        = number
  default     = 4
  description = "Maximum number of nodes"
}

variable "min_size" {
  type        = number
  default     = 2
  description = "Minimum number of nodes to maintain at any given point of time"
}

variable "capacity_type" {
  type        = string
  default     = "ON_DEMAND"
  description = "Type of purchase option to be used for EKS node. **Possible Values**: ON_DEMAND or SPOT"
}

variable "instance_type" {
  type        = string
  default     = "t3.medium"
  description = "Type of instance to be used for EKS nodes"
}

variable "disk_size" {
  type        = number
  default     = 20
  description = "Size of each EBS volume attached to EKS node"
}

variable "labels" {
  type        = map(string)
  default     = {}
  description = "Key Value pair of Kubernetes labels to apply on nodes"
}

variable "ami_type" {
  type        = string
  default     = "AL2_x86_64"
  description = "Type of AMI to be used for EKS node. Supported values: AL2_x86_64, AL2_ARM_64, AL2_x86_64_GPU(AMI with GPU support)"
}

variable "ssh_key_pair" {
  type        = string
  default     = ""
  description = "SSH Key pair to use for remote access of EKS node"
}

variable "sg_ids" {
  type        = list(string)
  default     = []
  description = "List of security groups id to attach to EKS nodes for restricting SSH access"
}
