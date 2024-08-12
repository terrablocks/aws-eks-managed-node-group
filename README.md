# Launch an EKS Managed Node Group

![License](https://img.shields.io/github/license/terrablocks/aws-eks-managed-node-group?style=for-the-badge) ![Plan](https://img.shields.io/github/actions/workflow/status/terrablocks/aws-eks-managed-node-group/tf-plan.yml?branch=main&label=Plan&style=for-the-badge) ![Checkov](https://img.shields.io/github/actions/workflow/status/terrablocks/aws-eks-managed-node-group/checkov.yml?branch=main&label=Checkov&style=for-the-badge) ![Commit](https://img.shields.io/github/last-commit/terrablocks/aws-eks-managed-node-group?style=for-the-badge) ![Release](https://img.shields.io/github/v/release/terrablocks/aws-eks-managed-node-group?style=for-the-badge)

This terraform module will deploy the following services:
- EKS Node Group
- Auto Scaling Group
- IAM Role
- IAM Role Policy

# Usage Instructions
## Example
```terraform
module "eks_worker" {
  source = "github.com/terrablocks/aws-eks-managed-node-group.git"

  cluster_name = "eks-cluster"
  subnet_ids   = ["subnet-xxxx", "subnet-yyyy"]
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13 |
| aws | >= 3.44.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cluster_name | Name of EKS cluster | `string` | n/a | yes |
| ng_name | Name of EKS Node Group. Default: {cluster_name}-ng | `string` | `""` | no |
| create_ng_role | Whether to create new IAM role for EKS nodes | `bool` | `true` | no |
| ng_role_arn | ARN of IAM role to associate with EKS nodes. Leave it blank to create IAM role with required permissions | `string` | `""` | no |
| subnet_ids | List of subnet ids to be used for launching EKS nodes | `list(string)` | n/a | yes |
| launch_template | A config block with launch template details<pre>{<br>  id      = ID of the EC2 Launch Template to use. **Note:** Either `id` or `name` is required<br>  name    = Name of the EC2 Launch Template to use. **Note:** Either `id` or `name` is required<br>  version = EC2 Launch Template version to use for launching instances<br>}</pre> | `map(any)` | `{}` | no |
| desired_size | Initial number of nodes to launch | `number` | `2` | no |
| max_size | Maximum number of nodes | `number` | `4` | no |
| min_size | Minimum number of nodes to maintain at any given point of time | `number` | `2` | no |
| capacity_type | Type of purchase option to be used for EKS node. **Possible Values**: ON_DEMAND or SPOT | `string` | `"ON_DEMAND"` | no |
| instance_type | Type of instance to be used for EKS nodes | `string` | `"t3.medium"` | no |
| disk_size | Size of each EBS volume attached to EKS node | `number` | `20` | no |
| labels | Key Value pair of Kubernetes labels to apply on nodes | `map(string)` | `{}` | no |
| ami_type | Type of AMI to be used for EKS node. Supported values: AL2_x86_64, AL2_ARM_64, AL2_x86_64_GPU(AMI with GPU support) | `string` | `"AL2_x86_64"` | no |
| remote_access | A config block with EC2 remote access details<pre>{<br>  ssh_key_name = Name of SSH key pair to associate to instances launched via node group<br>  sg_ids       = Security group ids to attach to instances launched via node group<br>}</pre> | `map(any)` | `{}` | no |
| taints | List of taint block to associate with node group. Maximum of 50 taints per node group are supported<pre>{<br>  key    = Key of taint<br>  value  = (Optional) Value of taint<br>  effect = Effect of taint. **Possible values:** NO_SCHEDULE, NO_EXECUTE or PREFER_NO_SCHEDULE<br>}</pre> | `list(any)` | `[]` | no |
| tags | Key Value pair to associate with node group | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| arn | ARN of EKS node group created |
| id | EKS Cluster name and EKS Node Group name separated by a colon |
| name | Name of the managed node group associated with the EKS cluster |
| cluster_name | Name of the EKS cluster attached to the node group |
| role_arn | ARN of the IAM role associated with EKS node group |
| role_name | Name of the IAM role associated with EKS node group |
| status | Status of the EKS node group |

## Cluster Autoscaler Setup (Source: [AWS](https://docs.aws.amazon.com/eks/latest/userguide/cluster-autoscaler.html#ca-deploy))
To enable Cluster Autoscaler execute the following steps:

#### Deploy Cluster Autoscaler:
```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/autoscaler/master/cluster-autoscaler/cloudprovider/aws/examples/cluster-autoscaler-autodiscover.yaml
```

#### Add annotation to `cluster-autoscaler` deployment:
```bash
kubectl -n kube-system annotate deployment.apps/cluster-autoscaler cluster-autoscaler.kubernetes.io/safe-to-evict="false"
```

#### Edit `custer-autoscaler` deployment and do the required changes:
```bash
kubectl -n kube-system edit deployment.apps/cluster-autoscaler
```

Replace `<YOUR CLUSTER NAME>` with your cluster's name, and add the following options:
- --balance-similar-node-groups
- --skip-nodes-with-system-pods=false

Example:
```
spec:
  containers:
  - command:
  - ./cluster-autoscaler
  - --v=4
  - --stderrthreshold=info
  - --cloud-provider=aws
  - --skip-nodes-with-local-storage=false
  - --expander=least-waste
  - --node-group-auto-discovery=asg:tag=k8s.io/cluster-autoscaler/enabled,k8s.io/cluster-autoscaler/<YOUR CLUSTER NAME>
  - --balance-similar-node-groups
  - --skip-nodes-with-system-pods=false
```

#### Set image for `cluster-autoscaler` deployment:

- Visit Cluster Autoscaler [releases](https://github.com/kubernetes/autoscaler/releases) to get the latest semantic version number for your kubernetes version. Eg: If your k8s version is 1.16, look for the latest release of cluster-autoscaler beginning with your k8s version and note down the semantic version (1.16.`x`)
- You can replace `us` with `asia` or `eu` as per proximity

```bash
kubectl -n kube-system set image deployment.apps/cluster-autoscaler cluster-autoscaler=us.gcr.io/k8s-artifacts-prod/autoscaling/cluster-autoscaler:v1.16.x
```

#### Verify Cluster Autoscaler deployment by checking logs:
```bash
kubectl -n kube-system logs -f deployment.apps/cluster-autoscaler
```

<!-- BEGIN_TF_DOCS -->
# Title

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
| ami_type | Type of AMI to be used for EKS worker node. Supported values: AL2_x86_64, AL2_ARM_64, AL2_x86_64_GPU(AMI with GPU support) | `string` | `"AL2_x86_64"` | no |
| capacity_type | Type of purchase option to be used for EKS worker node. **Possible Values**: ON_DEMAND or SPOT | `string` | `"ON_DEMAND"` | no |
| cluster_name | Name of EKS cluster | `string` | n/a | yes |
| create_ng_role | Whether to create new IAM role for EKS worker nodes | `bool` | `true` | no |
| desired_size | Initial number of worker nodes to launch | `number` | `2` | no |
| disk_size | Size of each EBS volume attached to EKS worker node | `number` | `20` | no |
| force_update_version | Forcefully perform version update for worker nodes if pod disruption prevents node draining | `bool` | `false` | no |
| instance_types | List of type of instances to be used as EKS worker nodes | `list(string)` | ```[ "t3.medium" ]``` | no |
| labels | Key Value pair of Kubernetes labels to apply on worker nodes | `map(string)` | `{}` | no |
| launch_template | A config block with launch template details ```{ id = ID of the EC2 Launch Template to use. **Note:** Either `id` or `name` is required name = Name of the EC2 Launch Template to use. **Note:** Either `id` or `name` is required version = EC2 Launch Template version to use for launching instances }``` | `map(any)` | `{}` | no |
| max_size | Maximum number of worker nodes | `number` | `4` | no |
| min_size | Minimum number of worker nodes to maintain at any given point of time | `number` | `2` | no |
| ng_name | Name of EKS Node Group. Default: {cluster_name}-ng | `string` | `""` | no |
| ng_role_arn | ARN of IAM role to associate with EKS worker nodes. Leave it blank to create IAM role with required permissions | `string` | `""` | no |
| remote_access | A config block with EC2 remote access details ```{ ssh_key_name = Name of SSH key pair to associate to instances launched via node group sg_ids = Security group ids to attach to instances launched via node group }``` | `map(any)` | `{}` | no |
| subnet_ids | List of subnet ids to be used for launching EKS worker nodes | `list(string)` | n/a | yes |
| tags | Key Value pair to associate with node group | `map(string)` | `{}` | no |
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
