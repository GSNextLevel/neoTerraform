resource "aws_launch_template" "custom_nodegrp_lt" {
  name = "custom-nodegrp"

  vpc_security_group_ids = [
    aws_security_group.cluster-additional-sg.id,
    aws_eks_cluster.eks_cluster.vpc_config[0].cluster_security_group_id
  ]

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = 30
      volume_type = "gp2"
    }
  }

  image_id      = var.image_id
  instance_type = var.instance_type
  key_name      = var.key_name

  user_data = base64encode(
    templatefile("userdata.tpl", {
      CLUSTER_NAME    = aws_eks_cluster.eks_cluster.name,
      NODE_GROUP_NAME = var.node_group_name,
      AMI_ID          = var.image_id,
      MAX_PODS        = 8
    })
  )

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name                                                        = "${var.node_group_name}"
      "kubernetes.io/cluster/${aws_eks_cluster.eks_cluster.name}" = "owned"
    }
  }
}
