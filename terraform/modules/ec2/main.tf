data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name = "name"
    # See https://cloud-images.ubuntu.com/locator/ec2/
    # values = ["ubuntu/images/hvm-ssd/ubuntu-focal-22.04-amd64-server-*"]
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

variable "ingressrules" {
  type    = list(number)
  default = [22, 8888]
}

resource "aws_security_group" "web_traffic" {
  name        = "Allow web traffic"
  description = "Allow ssh and strandard http/https inbound and everthing outbound"

  dynamic "ingress" {
    iterator = port
    for_each = var.ingressrules
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "TCP"
      cidr_blocks = var.ingress_cidr_blocks
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "instance" {
  ami             = data.aws_ami.ubuntu.id
  instance_type   = var.instance_type
  security_groups = [aws_security_group.web_traffic.name]
  key_name        = var.key_name
  root_block_device {
    volume_size = var.instance_volume_size
  }
  user_data = file("${path.module}/setup.sh")
  tags = {
    Name        = var.instance_name
    Environment = "dev"
  }
}

# Our user_data script will be executed as part of cloud-init final
# Block terraform until cloud-init has finished executing our script and the instance is ready.
# Create a special null_resource that will use remote-exec to wait until cloud-init has finished
resource "null_resource" "cloud_init_wait" {
  connection {
    host        = aws_instance.instance.public_ip
    user        = "ubuntu"
    private_key = file("~/.ssh/${var.key_name}.pem")
    timeout     = "10m"
  }
  provisioner "remote-exec" {
    inline = ["sudo cloud-init status --wait"]
  }
  depends_on = [aws_instance.instance]
}

# On termination of the script set an output variable containing the public ip
# of the instance so we can access it using ssh.
output "instance-public-ip" {
  value = aws_instance.instance.public_ip
}

output "ubuntu_ami" {
  value = data.aws_ami.ubuntu
}