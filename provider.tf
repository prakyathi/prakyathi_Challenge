  required_providers {
    aws = {
      version = ">= 3.8, < 4.8"
      source  = "hashicorp/aws"
    }
    template = {
      version = ">= 2.1, < 3.0"
      source  = "hashicorp/template"
    }
  }

}

provider "aws" {
  region = "ap-southeast-1"

}
