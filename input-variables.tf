#AWS Region
variable "region" {
  description = "Infrastructure Region ID"
  type        = string
  default     = "us-east-1"
}
#IAM User Access Key
variable "access_key" {
  description = "AccessKey For the IAM User"
  type        = string
  sensitive   = true
  default     = ""
}
#IAM User Secret Key
variable "secret_key" {
  description = "SecretKey for the IAM User"
  type        = string
  sensitive   = true
  default     = ""
}

variable "subnet_cidr_private" {
  description = "CIDR Blocks for Private Subnets"
  default     = ["10.20.20.0/28", "10.20.20.16/28"]
  type        = list(any)
}

variable "availability_zone" {
  description = "Availability Zones"
  default     = ["us-east-1a", "us-east-1b"]
  type        = list(any)
}
