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
  description = "Whether to create new IAM role for EKS worker nodes"
}

variable "ng_role_arn" {
  type        = string
  default     = ""
  description = "ARN of IAM role to associate with EKS worker nodes. Leave it blank to create IAM role with required permissions"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet ids to be used for launching EKS worker nodes"
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
  description = "Initial number of worker nodes to launch"
}

variable "max_size" {
  type        = number
  default     = 4
  description = "Maximum number of worker nodes"
}

variable "min_size" {
  type        = number
  default     = 2
  description = "Minimum number of worker nodes to maintain at any given point of time"
}

variable "capacity_type" {
  type        = string
  default     = "ON_DEMAND"
  description = "Type of purchase option to be used for EKS worker node. **Possible Values**: ON_DEMAND or SPOT"
}

variable "instance_types" {
  type        = list(string)
  default     = null
  description = "List of type of instances to be used as EKS worker nodes"
}

variable "disk_size" {
  type        = number
  default     = null
  description = "Size of each EBS volume attached to EKS worker node"
}

variable "labels" {
  type        = map(string)
  default     = {}
  description = "Key Value pair of Kubernetes labels to apply on worker nodes"
}

variable "ami_type" {
  type        = string
  default     = "AL2023_x86_64_STANDARD"
  description = "Refer to [AWS doc](https://docs.aws.amazon.com/eks/latest/APIReference/API_Nodegroup.html#AmazonEKS-Type-Nodegroup-amiType) for supported AMI types"
}

variable "ami_release_version" {
  type        = string
  default     = null
  description = "AMI version to use for EKS worker nodes. Leaving it to null will use latest available version"
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

variable "force_update_version" {
  type        = bool
  default     = false
  description = "Forcefully perform version update for worker nodes if pod disruption prevents node draining"
}

variable "enable_node_auto_repair" {
  type        = bool
  default     = true
  description = "Whether to enable node auto repair for the node group"
}

variable "max_unavailable" {
  type        = number
  default     = 1
  description = "Maximum number/percentage of nodes that can be unavailable during the node group update"
}

variable "max_unavailable_type" {
  type        = string
  default     = "count"
  description = "Type of maximum unavailable nodes. **Valid values:** count or percentage"

  validation {
    condition     = var.max_unavailable_type == "count" || var.max_unavailable_type == "percentage"
    error_message = "Invalid value for max_unavailable_type. Valid values: count or percentage"
  }
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Key Value pair to associate with EKS node group"
}
