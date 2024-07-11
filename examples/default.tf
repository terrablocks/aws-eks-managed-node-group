module "eks_managed_node_group" {
  source = "github.com/terrablocks/aws-eks-managed-node-group.git?ref=" # Always use `ref` to point module to a specific version or hash

  cluster_name = "eks-cluster"
  subnet_ids   = ["subnet-xxxx", "subnet-yyyy"]
}
