resource "aws_launch_template" "eks_nodes" {

  name_prefix = "${var.cluster_name}-"

  #image_id = data.aws_ssm_parameter.eks_ami.value

  #user_data = base64encode(
    #templatefile(
      #"${path.module}/userdata.sh",
      #{
        #cluster_name = var.cluster_name
      #}
    #)
  #)

  #vpc_security_group_ids = [
    #var.security_group_id
  #]

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${var.cluster_name}-worker"
    }
  }
}