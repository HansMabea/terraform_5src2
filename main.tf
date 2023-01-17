resource "aws_s3_bucket" "bucket_s3" {
  bucket = "bucket_s3"
}

resource "aws_s3_bucket_policy" "allow_access" {
  depends_on = [aws_instance.instance_EC2]
  bucket = aws_s3_bucket.bucket_s3.id
  policy = <<EOF
   {
	"Version": "2012-10-17",
	"Statement": [
		{
			"Sid": "Statement1",
			"Principal": "*",
			"Effect": "deny",
			"Action": [
				"s3:*"
			],
			"Resource": [
				"arn:aws:s3:::mybucket123esgi"
			],
			"Condition": {
				"NotIpAddress": {
					"aws:SourceIp": [
						"1.1.1.1/32"
					]
				}
			}
		}
	]
}
   EOF
}

resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr_block
}

resource "aws_subnet" "subnet" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.subnet_cidr_block
  availability_zone = var.aws_region
}

resource "aws_key_pair" "ssh-key" {
  key_name   = var.ssh_key_name
  public_key = var.public_ssh_key
}


resource "aws_instance" "instance_EC2" {
  ami                    = var.ec2_ami
  instance_type          = var.ec2_instance_type
  key_name               = aws_key_pair.ssh-key.key_name
  vpc_name               = var.vpc_name
  subnet_id              = aws_subnet.subnet.id
  tags = {
    Name = "instance_EC2-2"
  }
}


resource "aws_security_group" "security-group" {
  name = var.sg_name
  ingress = [{
    description      = "Autoriser SSH"
    cidr_blocks      = var.sg_egress_cidr_blocks
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
    from_port        = var.sg_egress_from_port
    to_port          = var.sg_egress_to_port
    protocol         = var.sg_egress_protocol
    cidr_blocks      = var.sg_egress_cidr_blocks
    self             = false
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []

  }]

}



