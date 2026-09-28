locals {
  controller_cidr = "${var.controller_ip}/32"

  # Built from the running instances and exposed as the inventory_ini output
  inventory_ini = join("\n", concat(
    flatten([
      for group in sort(distinct(values(var.servers))) : concat(
        ["[${group}]"],
        [
          for name in sort(keys(var.servers)) :
          "${name} ansible_host=${aws_instance.server[name].public_ip}"
          if var.servers[name] == group
        ],
        [""]
      )
    ]),
    ["[all:vars]", "ansible_user=ubuntu", ""]
  ))
}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# ---------------------------------------------------------------- network
resource "aws_vpc" "lab" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = { Name = "${var.project_name}-vpc" }
}

resource "aws_internet_gateway" "lab" {
  vpc_id = aws_vpc.lab.id

  tags = { Name = "${var.project_name}-igw" }
}

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.lab.id
  cidr_block        = var.subnet_cidr
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = { Name = "${var.project_name}-public-subnet" }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.lab.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.lab.id
  }

  tags = { Name = "${var.project_name}-public-rt" }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# ---------------------------------------------------------------- security
# Attached to every server: SSH from the Ansible controller only
resource "aws_security_group" "base" {
  name        = "${var.project_name}-base-sg"
  description = "SSH from the Ansible controller only"
  vpc_id      = aws_vpc.lab.id

  ingress {
    description = "SSH from the Ansible controller"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [local.controller_cidr]
  }

  egress {
    description = "All outbound for package installs"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.project_name}-base-sg" }
}

# Attached to web servers only: HTTP from the Ansible controller only
resource "aws_security_group" "web" {
  name        = "${var.project_name}-web-sg"
  description = "HTTP for web hosts from the Ansible controller only"
  vpc_id      = aws_vpc.lab.id

  ingress {
    description = "HTTP from the Ansible controller"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [local.controller_cidr]
  }

  tags = { Name = "${var.project_name}-web-sg" }
}

# ---------------------------------------------------------------- compute
resource "aws_key_pair" "controller" {
  key_name   = "${var.project_name}-controller"
  public_key = file(pathexpand(var.ssh_public_key_path))
}

resource "aws_instance" "server" {
  for_each = var.servers

  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public.id
  associate_public_ip_address = true
  key_name                    = aws_key_pair.controller.key_name

  # Web hosts get the extra HTTP group; everything else gets SSH only
  vpc_security_group_ids = each.value == "web" ? [aws_security_group.base.id, aws_security_group.web.id] : [aws_security_group.base.id]

  # Set the OS hostname to the role name so SSH and Ansible output is readable
  user_data                   = <<-CLOUDINIT
    #cloud-config
    hostname: ${each.key}
    manage_etc_hosts: true
  CLOUDINIT
  user_data_replace_on_change = true

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  root_block_device {
    volume_type = "gp3"
    encrypted   = true
  }

  tags = {
    Name = each.key
    Role = each.value
  }

  lifecycle {
    # A newer Ubuntu AMI release should not replace running lab servers
    ignore_changes = [ami]
  }
}
