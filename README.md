# Launch an EKS Managed Node Group

This terraform module will deploy the following services:
- EKS Node Group
- Launch Template
- Auto Scaling Group
- IAM Role
- IAM Policy

# Usage Instructions:
## Variables
| Parameter            | Type    | Description                                                                                              | Default    | Required |
|----------------------|---------|----------------------------------------------------------------------------------------------------------|------------|----------|
| cluster_name     | string  | Name of EKS cluster                                                                                      |            | Y        |
| node_group_name     | string  | Name of EKS Node Group                                                                                      | {cluster_name}-ng           | N        |
| subnet_ids           | list    | List of subnet ids to be used for launching EKS nodes                                                    |            | Y        |
| desired_size         | number  | Initial number of nodes to be created                                                                    | 2          | N        |
| max_size             | number  | Maximum number of nodes                                                                                  | 4          | N        |
| min_size             | number  | Minimum number of nodes to maintain at any given point of time                                           | 2          | N        |
| instance_type        | string  | Type of instance to be used for EKS nodes                                                                | t3.medium  | N        |
| disk_size            | number  | Size of EBS volume attached to each EKS node                                                             | 20         | N        |
| labels            | map  | Key-value map of Kubernetes labels to be apply on nodes                                                             |          | N        |
| ami_type             | string  | Type of AMI to be used for EKS node. Supported values: AL2_x86_64, AL2_x86_64_GPU(AMI with GPU support)  | AL2_x86_64 | N        |
| ssh_key_pair         | string  | SSH Key pair to be used to remotely access EKS node. |            | N        |
| sg_ids               | list    | List of security groups id to attach to EKS nodes for restricting SSH access.                 |            | N        |

## Outputs
| Parameter           | Type   | Description               |
|---------------------|--------|---------------------------|
| arn           | string | ARN of EKS node group created            |
| id | string | EKS Cluster name and EKS Node Group name separated by a colon       |
| cluster_name           | string | Name of EKS cluster attached to the node group            |
| role_name           | string | Name of IAM role created for node group            |
| status           | string | Status of EKS node group            |

## Deployment
- `terraform init` - download plugins required to deploy resources
- `terraform plan` - get detailed view of resources that will be created, deleted or replaced
- `terraform apply -auto-approve` - deploy the template without confirmation (non-interactive mode)
- `terraform destroy -auto-approve` - terminate all the resources created using this template without confirmation (non-interactive mode)
