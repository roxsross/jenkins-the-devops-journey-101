variable "app" {
    default = "nginx"
}
variable "env" {
    default = "dev"
}
variable "ami" {
    default = "ami-0fe472d8a85bc7b0e"
}
variable "instance_type" {
    default = "t2.micro"
}
variable "key" {
    default = "temporal"
}