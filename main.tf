module "environment" {
  source = "./modules/environment"

  vpc_cidr         = var.vpc_cidr
  env              = var.env
  project          = var.project
  prvt-subnet_cidr = var.prvt-subnet_cidr
  pblc-subnet_cidr = var.pblc-subnet_cidr

}

module "application" {
  source = "./modules/application"

  vpc_id                         = module.environment.vpc_id
  pblc-environment-subnet        = module.environment.pblc-subnet-id
  env                            = var.env
  project                        = var.project
  enable-pblc-ip-webserver-ec2   = var.enable-pblc-ip-webserver-ec2
  instance_type                  = var.instance_type
  sg-policy-cidr                 = var.sg-policy-cidr
  prvt-environment-subnet        = module.environment.prvt-subnet-id
  enable-prvt-ip-application-ec2 = var.enable-prvt-ip-webserver-ec2
}
