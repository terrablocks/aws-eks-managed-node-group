<!-- BEGIN_TF_DOCS -->
# Launch an EKS Managed Node Group

![License](https://img.shields.io/github/license/terrablocks/aws-eks-managed-node-group?style=for-the-badge) ![Plan](https://img.shields.io/github/actions/workflow/status/terrablocks/aws-eks-managed-node-group/tf-plan.yml?branch=main&label=Plan&style=for-the-badge) ![Checkov](https://img.shields.io/github/actions/workflow/status/terrablocks/aws-eks-managed-node-group/checkov.yml?branch=main&label=Checkov&style=for-the-badge) ![Commit](https://img.shields.io/github/last-commit/terrablocks/aws-eks-managed-node-group?style=for-the-badge) ![Release](https://img.shields.io/github/v/release/terrablocks/aws-eks-managed-node-group?style=for-the-badge)

This terraform module will deploy the following services:
- EKS Node Group
- Auto Scaling Group
- IAM Role
- IAM Role Policy

# Usage Instructions
## Example
```hcl
module "eks_managed_node_group" {
  source = "github.com/terrablocks/aws-eks-managed-node-group.git?ref=" # Always use `ref` to point module to a specific version or hash

  cluster_name = "eks-cluster"
  subnet_ids   = ["subnet-xxxx", "subnet-yyyy"]
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.8.0 |
| aws | >= 5.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| ami_release_version | AMI version to use for EKS worker nodes. Leaving it to null will use latest available version | `string` | `null` | no |
| ami_type | Refer to [AWS doc](https://docs.aws.amazon.com/eks/latest/APIReference/API_Nodegroup.html#AmazonEKS-Type-Nodegroup-amiType) for supported AMI types | `string` | `"AL2023_x86_64_STANDARD"` | no |
| capacity_type | Type of purchase option to be used for EKS worker node. **Possible Values**: `ON_DEMAND` or `SPOT` | `string` | `"ON_DEMAND"` | no |
| cluster_name | Name of EKS cluster | `string` | n/a | yes |
| create_ng_role | Whether to create new IAM role for EKS worker nodes | `bool` | `true` | no |
| desired_size | Initial number of worker nodes to launch | `number` | `2` | no |
| disk_size | Size of each EBS volume attached to EKS worker node. **Note:** Not required when using `launch_template` variable | `number` | `null` | no |
| enable_node_auto_repair | Whether to enable node auto repair for the node group | `bool` | `true` | no |
| force_update_version | Forcefully perform version update for worker nodes if pod disruption prevents node draining | `bool` | `false` | no |
| instance_types | List of type of instances to be used as EKS worker nodes. **Note:** Not required when using `launch_template` variable | `list(string)` | `null` | no |
| labels | Key Value pair of Kubernetes labels to apply on worker nodes | `map(string)` | `{}` | no |
| launch_template | A config block with launch template details ```{ id = ID of the EC2 Launch Template to use. **Note:** Either `id` or `name` is required name = Name of the EC2 Launch Template to use. **Note:** Either `id` or `name` is required version = EC2 Launch Template version to use for launching instances }``` | `map(any)` | `{}` | no |
| max_size | Maximum number of worker nodes | `number` | `4` | no |
| max_unavailable | Maximum number/percentage of nodes that can be unavailable during the node group update | `number` | `1` | no |
| max_unavailable_type | Type of maximum unavailable nodes. **Valid values:** count or percentage | `string` | `"count"` | no |
| min_size | Minimum number of worker nodes to maintain at any given point of time | `number` | `2` | no |
| ng_name | Name of EKS Node Group. Default: {cluster_name}-ng | `string` | `""` | no |
| ng_role_arn | ARN of IAM role to associate with EKS worker nodes. Leave it blank to create IAM role with required permissions | `string` | `""` | no |
| remote_access | A config block with EC2 remote access details ```{ ssh_key_name = Name of SSH key pair to associate to instances launched via node group sg_ids = Security group ids to attach to instances launched via node group }``` | `map(any)` | `{}` | no |
| subnet_ids | List of subnet ids to be used for launching EKS worker nodes | `list(string)` | n/a | yes |
| tags | Key Value pair to associate with EKS node group | `map(string)` | `{}` | no |
| taints | List of taint block to associate with node group. Maximum of 50 taints per node group are supported ```{ key = Key of taint value = (Optional) Value of taint effect = Effect of taint. **Possible values:** NO_SCHEDULE, NO_EXECUTE or PREFER_NO_SCHEDULE }``` | `list(any)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| arn | ARN of EKS node group created |
| cluster_name | Name of the EKS cluster attached to the node group |
| id | EKS Cluster name and EKS Node Group name separated by a colon |
| name | Name of the managed node group associated with the EKS cluster |
| role_arn | ARN of the IAM role associated with EKS node group |
| role_name | Name of the IAM role associated with EKS node group |
| status | Status of the EKS node group |

## Autoscaling nodes

For autoscaling nodes you can setup either of two:
- [Cluster Autoscaler](https://github.com/kubernetes/autoscaler/blob/master/cluster-autoscaler/cloudprovider/aws/README.md) - [Helm Chart](https://github.com/kubernetes/autoscaler/tree/master/charts/cluster-autoscaler)
- [Karpenter](https://karpenter.sh/) - [Helm Chart](https://github.com/aws/karpenter-provider-aws/tree/main/charts/karpenter)
<!-- END_TF_DOCS -->
