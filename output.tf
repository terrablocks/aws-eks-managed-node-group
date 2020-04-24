output "arn" {
  value = aws_eks_node_group.eks_ng.arn
}

output "id" {
  value = aws_eks_node_group.eks_ng.id
}

output "role_name" {
  value = aws_iam_role.eks_ng_role.name
}

output "status" {
  value = aws_eks_node_group.eks_ng.status
}
