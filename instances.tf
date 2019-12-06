data "aws_ami" "centos" {
owners      = ["679593333241"]
most_recent = true

  filter {
      name   = "name"
      values = ["CentOS Linux 7 x86_64 HVM EBS *"]
  }

  filter {
      name   = "architecture"
      values = ["x86_64"]
  }

  filter {
      name   = "root-device-type"
      values = ["ebs"]
  }
}

data "local_file" "ssh_key" {
  filename = pathexpand("~/.ssh/id_rsa.pub")
}


resource "aws_key_pair" "access_key" {
  key_name = "JRkey2.key"
  public_key = data.local_file.ssh_key.content
}

resource "aws_instance" "TFtestserver" {
  ami = data.aws_ami.centos.id
  instance_type = "t2.micro"
  key_name = aws_key_pair.access_key.key_name
  monitoring = false

  associate_public_ip_address = true

  tags = {
    Name = "TestServer-JR"
    Purpose = "Terraform test"
  }




}



output "instance_ip" {
  value = "${aws_instance.TFtestserver.*.public_ip}"
}

