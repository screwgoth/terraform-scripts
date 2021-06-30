provider "aws" {
  	region = var.region
}

data "aws_eks_cluster" "cluster" {
	name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
	name = module.eks.cluster_id
}

provider "kubernetes" {
	host = data.aws_eks_cluster.cluster.endpoint
	cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
	token = data.aws_eks_cluster_auth.cluster.token
	load_config_file = false
}

# data "aws_availability_zone" "available" {
# }


module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = var.cluster-name
  cluster_version = "1.20"
  subnets         = ["subnet-21518e0d", "subnet-bdd80ce7"]

  tags = {
    Environment = "dev"
    GithubRepo  = "terraform-aws-eks"
    GithubOrg   = "terraform-aws-modules"
  }

  vpc_id = "vpc-ca61abb3"

  workers_group_defaults = {
    root_volume_type = "gp2"
  }

  worker_groups = [
    {
      name                          = "worker-group-1"
      instance_type                 = "t2.small"
      additional_userdata           = "echo foo bar"
      asg_desired_capacity          = 2
      #additional_security_group_ids = [aws_security_group.worker_group_mgmt_one.id]
    },
    # {
    #   name                          = "worker-group-2"
    #   instance_type                 = "t2.medium"
    #   additional_userdata           = "echo foo bar"
    #   additional_security_group_ids = [aws_security_group.worker_group_mgmt_two.id]
    #   asg_desired_capacity          = 1
    # },
  ]
}

# module "eks" {
# 	source          = "terraform-aws-modules/eks/aws"
# 	cluster_name    = var.cluster-name
# 	cluster_version = "1.20"
# 	subnets         = ["subnet-21518e0d", "subnet-bdd80ce7"]
# 	vpc_id			= "vpc-ca61abb3"

# 	worker_groups = [
# 		{
#       		instance_type = "t2.medium"
#       		asg_max_size  = 5
#     	}
# 	]

# }