resource "aws_launch_template" "test_launch_template" {
  name = "test_launch_template"

  vpc_security_group_ids = [
    aws_security_group.cluster-additional-sg.id,
    aws_eks_cluster.eks_cluster.vpc_config[0].cluster_security_group_id
  ]

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = 100
      volume_type = "gp2"
    }
  }

  image_id      = var.image_id
  instance_type = var.instance_type
  key_name      = var.key_name

  user_data = base64encode(<<-EOF
    ${file("./bootstrapFile/${var.node_group_name}.sh")}
  EOF
  )

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "NodeGroup-Worker"
    }
  }
}
