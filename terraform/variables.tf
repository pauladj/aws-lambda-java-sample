variable "region" {
  type        = string
  description = "The region"
  default = "us-east-1"
}

variable "jar_file" {
  type = string
  description = "The name of the jar file of the application after building it with maven"
  default = "java-basic-1.0-SNAPSHOT.jar"
}

variable "application_handler" {
  type = string
  description = "The entry handler of the application (package:className)"
  default = "example.Handler"
}