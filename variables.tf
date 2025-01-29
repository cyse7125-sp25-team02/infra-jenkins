variable "region" {
  description = "Default region for all AWS resources"
  type        = string
}

variable "aws_profile" {
  description = "AWS Local Profile"
  type        = string
}

variable "jenkins_eip" {
  description = "Elastic IP which we got have to be attache to jenkins-server"
  type        = string
}

variable "jenkins_ec2_instance_type" {
  description = "Instance Type"
  type        = string
}

variable "jenkins_vpc_cidr" {
  description = "CIDR range of vpc"
  type        = string
}

variable "jenkins_subnet_cidr" {
  description = "Jenkins subnet CIDR range"
  type        = string
}

variable "jenkins_subnet_az" {
  description = "Jenkins subnet availability zone"
  type        = string
}

variable "jenkins_route_table_cidr" {
  description = "Jenkins route table CIDR range"
  type        = string
}

variable "jenkins_ami_filter_parameter" {
  description = "Jenkins AMI filter parameter"
  type        = string
}

variable "tags" {
  description = "Includes tags for all the resources"
  type        = map(string)
}
