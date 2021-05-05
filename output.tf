output "arn" {
  value       = "${join(", ", aws_eks_node_group.eks_ng.*.arn)}${join(", ", aws_eks_node_group.eks_ng_ssh.*.arn)}"
  description = "ARN of EKS node group created"
}

output "id" {
  value       = "${join(", ", aws_eks_node_group.eks_ng.*.id)}${join(", ", aws_eks_node_group.eks_ng_ssh.*.id)}"
  description = "EKS Cluster name and EKS Node Group name separated by a colon"
}

output "cluster_name" {
  value       = "${join(", ", aws_eks_node_group.eks_ng.*.cluster_name)}${join(", ", aws_eks_node_group.eks_ng_ssh.*.cluster_name)}"
  description = "Name of EKS cluster attached to the node group"
}

output "role_arn" {
  value       = local.node_role_arn
  description = "ARN of IAM role associated with EKS node group"
}

output "status" {
  value       = "${join(", ", aws_eks_node_group.eks_ng.*.status)}${join(", ", aws_eks_node_group.eks_ng_ssh.*.status)}"
  description = "Status of EKS node group"
}
