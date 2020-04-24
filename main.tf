resource "aws_eks_node_group" "eks_ng" {
  cluster_name    = var.eks_cluster_name
  node_group_name = "${var.eks_cluster_name}-eks-node-group"
  node_role_arn   = aws_iam_role.eks_ng_role.arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  instance_types = [var.instance_type]
  disk_size      = var.disk_size
  ami_type       = var.ami_type

  remote_access {
    ec2_ssh_key               = var.enable_remote_access == true ? var.ssh_key_pair : null
    source_security_group_ids = length(var.sg_ids) == 0 ? null : var.sg_ids
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.ng_worker_policy,
    aws_iam_role_policy_attachment.ng_cni_policy,
    aws_iam_role_policy_attachment.ng_registry_policy,
  ]
}

resource "aws_iam_role" "eks_ng_role" {
  name_prefix = "${var.eks_cluster_name}-ng-role"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "ng_worker_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_ng_role.name
}

resource "aws_iam_role_policy_attachment" "ng_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_ng_role.name
}

resource "aws_iam_role_policy_attachment" "ng_registry_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_ng_role.name
}

resource "aws_iam_role_policy_attachment" "ssm_policy" {
  count      = var.enable_ssm_access ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.eks_ng_role.name
}
