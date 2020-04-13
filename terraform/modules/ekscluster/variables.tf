variable "env" {
  description = "The name of the environment, e.g. development, staging, production..."
  type        = string
}

variable "project" {
  description = "name used to identify a project"
  type        = string
}

variable "cluster_name" {
  description = "name to be used to identify the cluster"
  type        = string
}

variable "vpc_id" {
  description = "id of the vcp where the server is"
  type        = string
}

variable "subnet_id_az1" {
  description = "subnet id in az a for control plane and workers"
  type        = string
}

variable "subnet_id_az2" {
  description = "subnet id in az b for control plane and workers, if you want workers there"
  type        = string
}

variable "subnet_id_az3" {
  description = "subnet id in az c for control plane and workers, if you want workers there, leave empty if you don't want it"
  type        = string
  default     = ""
}

variable "want_workers_in_az2" {
  description = "true if you want worker nodes in az 2"
  type        = bool
  default     = false
}

variable "want_workers_in_az3" {
  description = "true if you want worker nodes in az 3, in this case subnet_id_az3 must not be empty"
  type        = bool
  default     = false
}

variable "ec2_ssh_key" {
  description = "ssh key name to log in to the workers"
  type        = string
}

variable "ssh_access_worker_cidr" {
  description = "list of CIDRs that can connect to the workers via ssh"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "instance_type" {
  description = "instance type for the server, e.g. m5.large... (keep in mind aws cni limits)"
  # to undestand how many pods in an instace type goes see https://docs.google.com/spreadsheets/d/1MCdsmN7fWbebscGizcK6dAaPGS-8T_dYxWp0IdwkMKI/edit?usp=sharing
  type        = string
  default     = "m5.large"
}

variable "asg_max_size" {
  description = "max size of autoscaling group for each worker node group"
  type        = string
  default     = 2
}

variable "sg_min_size" {
  description = "min size of autoscaling group for each worker node group"
  type        = string
  default     = 1
}

variable "sg_desired_size" {
  description = "desired size of autoscaling group for each worker node group"
  type        = string
  default     = 1
}

variable "node_disk_size" {
  description = "size in GB for root disk of nodes"
  type        = string
  default     = 20
}