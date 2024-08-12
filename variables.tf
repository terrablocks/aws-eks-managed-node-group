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

variable "launch_template" {
  type        = map(any)
  default     = {}
  description = <<-EOT
    A config block with launch template details
    ```{
      id      = ID of the EC2 Launch Template to use. **Note:** Either `id` or `name` is required
      name    = Name of the EC2 Launch Template to use. **Note:** Either `id` or `name` is required
      version = EC2 Launch Template version to use for launching instances
    }```
  EOT
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
  type        = list(string)
  default     = ["t3.medium"]
  description = "List of type of instances to be used as EKS nodes"
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

variable "remote_access" {
  type        = map(any)
  default     = {}
  description = <<-EOT
    A config block with EC2 remote access details
    ```{
      ssh_key_name = Name of SSH key pair to associate to instances launched via node group
      sg_ids       = Security group ids to attach to instances launched via node group
    }```
  EOT
}

variable "taints" {
  type        = list(any)
  default     = []
  description = <<-EOT
    List of taint block to associate with node group. Maximum of 50 taints per node group are supported
    ```{
      key    = Key of taint
      value  = (Optional) Value of taint
      effect = Effect of taint. **Possible values:** NO_SCHEDULE, NO_EXECUTE or PREFER_NO_SCHEDULE
    }```
  EOT
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Key Value pair to associate with node group"
}
