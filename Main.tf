provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}
resource "aws_instance" "example" {
        ami = "${var.ami}"
        instance_type = "${var.instance_type}"
        key_name = "${var.key_name}"
                subnet_id = "${var.ec2_subnet}"
        security_groups = ["${var.ec2_security_groups}"]
                associate_public_ip_address = "true"
        tags {
         Name = "jai-teraform-test"

        }
        user_data = "${file("./apache.sh")}"

}
resource "aws_elb" "example" {
  name               = "terraform-elb"
  subnets = ["${var.elb_subnet}"]
  security_groups =["${var.elb_security_groups}"]



  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }



  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/index.php"
    interval            = 30
  }

  instances                   = ["${aws_instance.example.id}"]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400
  
  tags {
    Name = "example-terraformelb"
  }
}

