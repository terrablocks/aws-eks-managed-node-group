resource "aws_iam_role" "eks_ng_role" {
  count                 = var.create_ng_role ? 1 : 0
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
  count      = var.create_ng_role ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = join(", ", aws_iam_role.eks_ng_role[*].name)
}

resource "aws_iam_role_policy_attachment" "ng_cni_policy" {
  count      = var.create_ng_role ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = join(", ", aws_iam_role.eks_ng_role[*].name)
}

resource "aws_iam_role_policy_attachment" "ng_registry_policy" {
  count      = var.create_ng_role ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = join(", ", aws_iam_role.eks_ng_role[*].name)
}

# Policy required for cluster autoscaling
resource "aws_iam_role_policy" "eks_scaling_policy" {
  # checkov:skip=CKV_AWS_290: write access without constraint is required
  # checkov:skip=CKV_AWS_355: "*" for resource is required
  count       = var.create_ng_role ? 1 : 0
  name_prefix = "${var.cluster_name}-ng-role-policy-"
  role        = join(", ", aws_iam_role.eks_ng_role[*].id)

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

locals {
  node_role_arn = var.create_ng_role ? join(", ", aws_iam_role.eks_ng_role[*].arn) : var.ng_role_arn
}

resource "aws_eks_node_group" "eks_ng" {
  cluster_name         = var.cluster_name
  node_group_name      = var.ng_name == "" ? "${var.cluster_name}-ng" : var.ng_name
  node_role_arn        = local.node_role_arn
  subnet_ids           = var.subnet_ids
  ami_type             = var.ami_type
  release_version      = var.ami_release_version
  disk_size            = var.disk_size
  force_update_version = var.force_update_version
  instance_types       = var.instance_types

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  dynamic "launch_template" {
    for_each = length(var.launch_template) == 0 ? [] : [var.launch_template]
    content {
      id      = lookup(launch_template.value, "id", null)
      name    = lookup(launch_template.value, "name", null)
      version = lookup(launch_template.value, "version", null)
    }
  }

  dynamic "remote_access" {
    for_each = length(var.remote_access) == 0 ? [] : [var.remote_access]
    content {
      ec2_ssh_key               = lookup(remote_access.value, "ssh_key_name", null)
      source_security_group_ids = lookup(remote_access.value, "sg_ids", null)
    }
  }

  dynamic "taint" {
    for_each = var.taints
    content {
      key    = lookup(taint.value, "key", null)
      value  = lookup(taint.value, "value", null)
      effect = lookup(taint.value, "effect", null)
    }
  }

  capacity_type = var.capacity_type

  labels = length(var.labels) == 0 ? null : var.labels

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.ng_worker_policy,
    aws_iam_role_policy_attachment.ng_cni_policy,
    aws_iam_role_policy_attachment.ng_registry_policy,
  ]

  tags = var.tags

  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }
}
