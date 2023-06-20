#vpc default

data "aws_vpc" "default" {
    default = true
}

