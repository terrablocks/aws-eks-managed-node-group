output "arn" {
  value = "${join(", ", aws_eks_node_group.eks_ng.*.arn)}${join(", ", aws_eks_node_group.eks_ng_ssh.*.arn)}"
}

output "id" {
  value = "${join(", ", aws_eks_node_group.eks_ng.*.id)}${join(", ", aws_eks_node_group.eks_ng_ssh.*.id)}"
}

output "cluster_name" {
  value = "${join(", ", aws_eks_node_group.eks_ng.*.cluster_name)}${join(", ", aws_eks_node_group.eks_ng_ssh.*.cluster_name)}"
}

output "role_arn" {
  value = local.node_role_arn
}

output "status" {
  value = "${join(", ", aws_eks_node_group.eks_ng.*.status)}${join(", ", aws_eks_node_group.eks_ng_ssh.*.status)}"
}
