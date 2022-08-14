output "arn" {
  value       = aws_eks_node_group.eks_ng.arn
  description = "ARN of EKS node group created"
}

output "id" {
  value       = aws_eks_node_group.eks_ng.id
  description = "EKS Cluster name and EKS Node Group name separated by a colon"
}

output "name" {
  value       = aws_eks_node_group.eks_ng.node_group_name
  description = "Name of the managed node group associated with the EKS cluster"
}

output "cluster_name" {
  value       = aws_eks_node_group.eks_ng.cluster_name
  description = "Name of the EKS cluster attached to the node group"
}

output "role_arn" {
  value       = local.node_role_arn
  description = "ARN of the IAM role associated with EKS node group"
}

output "role_name" {
  value       = split("/", local.node_role_arn)[1]
  description = "Name of the IAM role associated with EKS node group"
}

output "status" {
  value       = aws_eks_node_group.eks_ng.status
  description = "Status of the EKS node group"
}
