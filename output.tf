output "arn" {
  value       = aws_eks_node_group.eks_ng.arn
  description = "ARN of EKS node group created"
}

output "id" {
  value       = aws_eks_node_group.eks_ng.id
  description = "EKS Cluster name and EKS Node Group name separated by a colon"
}

output "cluster_name" {
  value       = aws_eks_node_group.eks_ng.cluster_name
  description = "Name of EKS cluster attached to the node group"
}

output "role_arn" {
  value       = local.node_role_arn
  description = "ARN of IAM role associated with EKS node group"
}

output "status" {
  value       = aws_eks_node_group.eks_ng.status
  description = "Status of EKS node group"
}
