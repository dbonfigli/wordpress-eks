# EKS CLuster module

This module creates all the necessary resources needed for an EKS cluster, i.e.:
- the EKS cluster itself;
- oidc provider to let pods authenticate against iam;
- managed worker groups;
- iam roles to are ususally used by "system" pods (ingress controllers...)

A VPC must be already in place, with at least two AZs and subnets tagged with the specific tags required by EKS:
- each subnet (public _and_ private) *must* be tagged with the tag ```kubernetes.io/cluster/<cluster-name>: shared``` (this is done by EKS at creation, but only for the subnets where the control plane is)
- each private subnet *must* be tagged with the tag ```kubernetes.io/role/internal-elb: 1```;
- each public subnet *must* be tagged with the tag ```kubernetes.io/role/elb: 1```;
- private subnets must have internet connectivity.

Each worker group is created to span only one AZ to avoid problems with volumes and cluster autoscaling, if you want multi AZ you should create multiple worker groups on different AZs, this is done setting the variables ```want_workers_in_az2``` and ```want_workers_in_az3```.