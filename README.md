# Launch an EKS Managed Node Group

This terraform module will deploy the following services:
- EKS Node Group
- Launch Template
- Auto Scaling Group
- IAM Role
- IAM Role Policy

# Usage Instructions:
## Variables
| Parameter            | Type    | Description                                                                                              | Default    | Required |
|----------------------|---------|----------------------------------------------------------------------------------------------------------|------------|----------|
| cluster_name     | string  | Name of EKS cluster                                                                                      |            | Y        |
| node_group_name     | string  | Name of EKS Node Group                                                                                      | {cluster_name}-ng           | N        |
| subnet_ids           | list    | List of subnet ids to be used for launching EKS nodes                                                    |            | Y        |
| desired_size         | number  | Initial number of nodes to launch                                                                    | 2          | N        |
| max_size             | number  | Maximum number of nodes                                                                                  | 4          | N        |
| min_size             | number  | Minimum number of nodes to maintain at any given point of time                                           | 2          | N        |
| instance_type        | string  | Type of instance to be used for EKS nodes                                                                | t3.medium  | N        |
| disk_size            | number  | Size of each EBS volume attached to EKS node                                                             | 20         | N        |
| labels            | map  | Key-value map of Kubernetes labels to be apply on nodes                                                             |          | N        |
| ami_type             | string  | Type of AMI to be used for EKS node. Supported values: AL2_x86_64, AL2_x86_64_GPU(AMI with GPU support)  | AL2_x86_64 | N        |
| ssh_key_pair         | string  | SSH Key pair to use for remote access of EKS node |            | N        |
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

## Cluster Autoscaler Setup (Source: [AWS](https://docs.aws.amazon.com/eks/latest/userguide/cluster-autoscaler.html#ca-deploy))
To enable Cluster Autoscaler execute the following steps:

#### Deploy Cluster Autoscaler:
```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/autoscaler/master/cluster-autoscaler/cloudprovider/aws/examples/cluster-autoscaler-autodiscover.yaml
```

#### Add annotation to `cluster-autoscaler` deployment:
```
kubectl -n kube-system annotate deployment.apps/cluster-autoscaler cluster-autoscaler.kubernetes.io/safe-to-evict="false"
```

#### Edit `custer-autoscaler` deployment and do the required changes:
```
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

```
kubectl -n kube-system set image deployment.apps/cluster-autoscaler cluster-autoscaler=us.gcr.io/k8s-artifacts-prod/autoscaling/cluster-autoscaler:v1.16.x
```

#### Verify Cluster Autoscaler deployment by checking logs:
```
kubectl -n kube-system logs -f deployment.apps/cluster-autoscaler
```
