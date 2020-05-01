resource "aws_eks_node_group" "eks_ng" {
  count           = var.enable_remote_access == true ? 0 : 1
  cluster_name    = var.cluster_name
  node_group_name = var.node_group_name == "" ? "${var.cluster_name}-ng" : var.node_group_name
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

  labels = length(var.labels) == 0 ? null : var.labels

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.ng_worker_policy,
    aws_iam_role_policy_attachment.ng_cni_policy,
    aws_iam_role_policy_attachment.ng_registry_policy,
  ]
}

resource "aws_eks_node_group" "eks_ng_ssh" {
  count           = var.enable_remote_access == true ? 1 : 0
  cluster_name    = var.cluster_name
  node_group_name = var.node_group_name == "" ? "${var.cluster_name}-ng" : var.node_group_name
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

  labels = length(var.labels) == 0 ? null : var.labels

  remote_access {
    ec2_ssh_key               = var.ssh_key_pair
    source_security_group_ids = var.sg_ids
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
  name_prefix           = "${var.cluster_name}-ng-role-"
  force_detach_policies = true

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

# Policy required for cluster autoscaling
resource "aws_iam_role_policy" "eks_scaling_policy" {
  name_prefix = "${var.cluster_name}-ng-role-policy-"
  role        = aws_iam_role.eks_ng_role.id

  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "autoscaling:DescribeAutoScalingGroups",
          "autoscaling:DescribeAutoScalingInstances",
          "autoscaling:DescribeLaunchConfigurations",
          "autoscaling:DescribeTags",
          "autoscaling:SetDesiredCapacity",
          "autoscaling:TerminateInstanceInAutoScalingGroup",
          "ec2:DescribeLaunchTemplateVersions"
        ],
        "Effect": "Allow",
        "Resource": "*"
      }
    ]
  }
  EOF
}
