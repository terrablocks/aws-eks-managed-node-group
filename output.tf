output "eks_ng_arn" {
  value = aws_eks_node_group.eks_ng.arn
}

output "eks_ng_id" {
  value = aws_eks_node_group.eks_ng.id
}
