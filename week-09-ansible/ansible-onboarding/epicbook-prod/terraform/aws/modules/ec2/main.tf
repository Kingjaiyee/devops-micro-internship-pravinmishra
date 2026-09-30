# Only the public key is registered with AWS. The private key stays on the controller.
resource "aws_key_pair" "deployer" {
  key_name   = "${var.project_name}-aws-key"
  public_key = file(pathexpand(var.public_key_path))
}

# Latest Ubuntu 24.04 LTS image. 099720109477 is Canonical's public
# publisher ID, not a personal account ID.
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# No user_data: Ansible roles configure this server after it is created.
resource "aws_instance" "epicbook" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.security_group_id]
  key_name                    = aws_key_pair.deployer.key_name
  associate_public_ip_address = true

  metadata_options {
    http_tokens = "required"
  }

  root_block_device {
    volume_type = "gp3"
    encrypted   = true
  }

  tags = {
    Name = "${var.project_name}-app-server"
  }

  lifecycle {
    # A newer Ubuntu AMI release should not replace the running server
    ignore_changes = [ami]
  }
}
