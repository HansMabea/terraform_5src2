### Instance EC2 (VM)
####     ----> SSH-PUBLIC-KEY --> DONE
####     ----> SG (Sécurity Group) [22/TCP]  --> DONE

# Axes d'améliorations
# 
# - Commennter le code 
# - Variaviliser les élèments pour le rendre universel
#?? 

resource "aws_key_pair" "myssh-key" {
  key_name   = var.ssh_key_name 
  public_key = var.public_ssh_key 
}


resource "aws_security_group" "my-sg" {

  #description = "security group to allow incoming SSH connection to ec2 instance"
  name        = "mysg"

  ingress = [{
    cidr_blocks      = ["0.0.0.0/0"]
    description      = "Allow SSH"
    from_port        = 22
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "TCP"
    security_groups  = []
    self             = false
    to_port          = 22
  }]

  egress = [{
    description      = "Allow connection to any internet service"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    self             = false
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []

  }]

}


resource "aws_instance" "myec2" {

  ami             = "ami-0574da719dca65348"
  instance_type   = "t2.medium"
  key_name        = aws_key_pair.myssh-key.key_name # 1ère variable terraform
  security_groups = [aws_security_group.my-sg.name]
  tags = {
    "Name" = "myvm"
  }

}