# infra-jenkins
This repository contains Terraform configurations to set up Jenkins infrastructure in AWS.

## Prerequisites
 - AWS CLI configured with appropriate profiles
 - Terraform >= 1.3.7
 - A registered domain name
 - Route 53 hosted zone configured
 - Jenkins AMI created using Packer
 - Elastic IP allocated in AWS

## Usage
1. Clone the repository:

   ```
   git clone git@github.com:your-org/infra-jenkins.git
   ```
2. Create terraform.tfvars with required variables from the variables.tf:
   
    ```
      domain_name     = "yourdomain.tld"
      email           = "your-email@domain.com"
      jenkins_ami_id  = "ami-xxxxx"
      vpc_cidr        = "10.0.0.0/16"
      elastic_ip_id   = "eipalloc-xxxxx"
      ...etc
    ```
3. Initialize Terraform:
     ```
     terraform init
     ```
4. Apply the configuration:
   ```
   terraform apply -var-file="terraform.tfvars"
   ```

## Teardown Process
To destroy the infrastructure:
  ```
  terraform destroy -var-file="terraform.tfvars"
  ```

## Note: This will:
 - Terminate the EC2 instance
 - Disassociate (but not release) the Elastic IP
 - Remove all created AWS resources except the Elastic IP
