resource "aws_instance" "web-1" {
  ami                         = "ami-05c172c7f0d3aed00"
  availability_zone           = "eu-west-2a"
  instance_type               = "t2.micro"
  key_name                    = "LB"
  subnet_id                   = aws_subnet.subnet1-public.id
  vpc_security_group_ids      = ["${aws_security_group.allow_all.id}"]
  associate_public_ip_address = true
  tags = {
    Name       = "Server-Terraform-Insatlled"
    Env        = "Prod"
    Owner      = "sai"
    CostCenter = "ABCD"
  }
  user_data = <<-EOF
     #!/bin/bash
     	sudo apt-get update
     	sudo apt-get install -y nginx
     	echo "<h1>${var.env}-Server-1</h1>" | sudo tee /var/www/html/index.html
     	sudo systemctl start nginx
     	sudo systemctl enable nginx
     EOF

}
