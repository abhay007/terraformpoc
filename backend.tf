terraform {
  backend "s3" {
    bucket  = "abhay-terraform-test"
    encrypt = true
    key     = "tf/aws-elb-ec2/terraform.tfstate"
    region  = "us-east-1"
  }
}