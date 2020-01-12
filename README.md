# Launch an EKS Managed Node Group

This terraform module will deploy the following services:
- EC2 Instances
- IAM Role

# Usage Instructions:
## Variables
| Parameter            | Type    | Description                                                                                              | Default    | Required |
|----------------------|---------|----------------------------------------------------------------------------------------------------------|------------|----------|
| eks_cluster_name     | string  | Name of EKS cluster                                                                                      |            | Y        |
| subnet_ids           | list    | List of subnet ids to be used for launching EKS nodes                                                    |            | Y        |
| desired_size         | number  | Initial number of nodes to be created                                                                    | 2          | N        |
| max_size             | number  | Maximum number of nodes                                                                                  | 2          | N        |
| min_size             | number  | Minimum number of nodes to maintain at any given point of time                                           | 2          | N        |
| instance_type        | string  | Type of instance to be used for EKS nodes                                                                | t3.medium  | N        |
| disk_size            | number  | Size of EBS volume attached to each EKS node                                                             | 20         | N        |
| ami_type             | string  | Type of AMI to be used for EKS node. Supported values: AL2_x86_64, AL2_x86_64_GPU(AMI with GPU support)  | AL2_x86_64 | N        |
| enable_remote_access | boolean | Whether to enable remote access to EKS nodes.                                                            | false      | N        |
| ssh_key_pair         | string  | SSH Key pair to be used to remotely access EKS node. **Required if enable_remote_access is set to true** |            | N        |
| sg_ids               | list    | List of security group ids to attach to EKS nodes for restricting SSH access if enabled.                 |            | N        |

## Outputs
| Parameter           | Type   | Description               |
|---------------------|--------|---------------------------|
| eks_ng_arn           | string | ARN of EKS node group created            |
| eks_ng_id | string | EKS Cluster name and EKS Node Group name separated by a colon       |

## Deployment
- `terraform init` - download plugins required to deploy resources
- `terraform plan` - get detailed view of resources that will be created, deleted or replaced
- `terraform apply -auto-approve` - deploy the template without confirmation (non-interactive mode)
- `terraform destroy -auto-approve` - terminate all the resources created using this template without confirmation (non-interactive mode)
