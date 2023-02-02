variable "my_vpc" {
    type = string
    default = "192.168.0.0/16"
  
}
variable "my_sub" {
    type = list(string)
  
  }
  variable "my_route_tables" {
    type = list(string)
    
  }
  variable "my_tags" {
    type = list(string)
    
  }
  variable "region" {
    type = string
    default = "us-west-2"
    
  }
  variable "destinationcidr" {
    type = string
    default = "0.0.0.0/0"
    
  }
  variable "ami_id" {
    type = string
    default = "ami-095413544ce52437d"
    
  }
  variable "instance_type" {
    type= string
    default = "t2.micro"
    
  }
  variable "hostname" {
    type = string
    default = "52.33.230.2"
    
  }
  variable "webtriggers" {
    type = string
    
  }