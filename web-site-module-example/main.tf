provider "aws" {
  region     = "us-east-1"
}

resource "aws_instance" "example" {
  ami = "ami-c80b0aa2"  #### ubuntu-trusty-14.04-amd64
  instance_type = "t2.micro"
  subnet_id = "subnet-d08c7cee"
  security_groups = [ "${aws_security_group.sg.id}" ]
}

terraform {
  backend "s3" {
    bucket     = "${S3_BUCKET}"
    key        = "${S3_OBJECT}"
    region     = "${S3_BUCKET_REGION}"
    # O Terraform também oferece a opção de utilizar uma tabela no DynamoDB (https://aws.amazon.com/pt/dynamodb/)
    # como lock para o estado em questão, evitando condições de corrida no arquiv.
    lock_table = "terraform_state_locking"
  }
}

resource "aws_elb" "elb" {
  name = "${var.name}"
  security_groups = [ "${aws_security_group.sg.id}" ]
  subnets = ["subnet-d08c7cee"]
  cross_zone_load_balancing = true
  instances = ["${aws_instance.example.id}"]

  listener {
    instance_port = "80"
    instance_protocol = "tcp"
    lb_port = "80"
    lb_protocol = "tcp"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "HTTP:80/check"
    interval = 5
  }
  tags {
    Name = "${var.name}"
    Environment = "${var.environment}"
  }
}

resource "aws_security_group" "sg" {
  name = "${var.name}-sg"
  description = "Allow all inbound traffic"
  vpc_id = "${var.vpc_id}"
  ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
      from_port = 0
      to_port = 65535
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
}
