resource "aws_s3_bucket" "bucket_s3" {
  bucket = "bucket_s3"
}

resource "aws_iam_role" "iam_role" {
  name = "iam_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "iam_role_policy" {
  name = "policy"
  role = aws_iam_role.iam_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket",
        "s3:GetObject"
      ],
      "Resource": [
        "arn:aws:s3:::bucket_s3",
        "arn:aws:s3:::bucket_s3/*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "profile" {
  name  = "profile"
  role = aws_iam_role.iam_role.name 
}

resource "aws_instance" "instance_EC2" {
  ami           = "ami-0ff8a91507f77f867"
  instance_type = "t2.micro"
  iam_instance_profile = aws_iam_instance_profil.profile.name
  tags = {
    Name = "instance_EC2"
  }
}

# Configuration SSH
resource "aws_key_pair" "myssh-key" {
  key_name   = var.ssh_key_name
  public_key = var.public_ssh_key
}

# Configuration SG
resource "aws_security_group" "my-sg" {
  name = var.sg_name

  ingress = [{
    cidr_blocks      = var.sg_ingress_cidr_blocks
    description      = "Autoriser SSH"
    from_port        = var.sg_ingress_from_port
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = var.sg_ingress_protocol
    security_groups  = []
    self             = false
    to_port          = var.sg_ingress_to_port
  }]

  egress = [{
    description      = "Allow connection to any internet service"
    from_port        = 0
    to_port          = 0
    protocol         = var.sg_egress_protocol
    cidr_blocks      = var.sg_egress_cidr_blocks
    self             = false
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []

  }]

}
resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "subnet" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1"
}

resource "aws_instance" "instance_2" {
  ami           = "ami-0ff8a91507f77f867"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.my-sg.id]
  subnet_id = aws_subnet.subnet.id
  tags = {
    Name = "instance_2"
  }
}
# Configuration EC2
resource "aws_instance" "myec2" {

  ami             = var.ec2_ami
  instance_type   = var.ec2_instance_type
  key_name        = aws_key_pair.myssh-key.key_name
  security_groups = [aws_security_group.my-sg.name]
  tags = {
    "Name" = var.ec2_name
  }

}

