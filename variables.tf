variable "aws_region" {

  default = "eu-west-1"
  type    = string
}


variable "vpc_cidr" {

  default = "10.0.0.0/16"
  type    = string

}

variable "public_subnet_cidr" {

  description = "cidr block for public subnet"

  default = "10.0.0.0/24"
  type    = string
}

variable "private_subnet_cidr" {
  description = "cidr block for private subnet"
  default     = "10.0.1.0/24"
}



#for ec2


variable "instance_type" {
  description = "ec2 instance type"
  default     = "t3.micro"
  type        = string
}

variable "key_name" {
  description = "existing aws keypair name"
  type        = string


}
