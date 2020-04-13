# Terraform

Terraform files are organized this way:
- ```modules``` directory: the directory where modules for this projects are;
- ```live``` directory: the directoty where actual tf files are, ready to be applied.

To create the infrastructure from this directory, change ```live/wpsite/config.tf``` (where terraform and provider configs are) and ```live/wpsite/main.tf``` (where resources are configured) according to you needs, and run ```terraform apply```.