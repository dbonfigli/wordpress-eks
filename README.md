# Wordpress Site in EKS

This project create all the necessary infrastructure to host a wordpress site in EKS.

To have a working site from scratch, do the following.

Create the aws resources using terraform:
- configure the module that create the EKS cluster setting at ```terraform/live/wpsite/main.tf``` and ```terraform/live/wpsite/config.tf``` for your environment, then ```terraform apply```.

Build the docker image and upload it to ecr:
- download / move wordpress files to ```WPDockerImage/wordpress```, the files in this directory will be the ones to be served; as an example you can take the latest wordpress version with ```wget https://wordpress.org/latest.zip && unzip latest.zip && mv wordpress WPDockerImage/```;
- build the docker image with ```docker build -t mywordpress:0.3 WPDockerImage```;
- tag it with ```docker tag mywordpress:0.2 <ecrurl>/mywordpress:0.3```;
- set up docker ecr credentials with ```$(aws ecr get-login)```;
- push the image with ```docker push <ecrurl>/mywordpress:0.3```.

Set up the access to the eks cluster with:
```bash
aws eks update-kubeconfig --name <eks_cluster_name>
```

Change helm 3 chart values files locate at ```kubernetes/values``` directory and set up basic kubernetes resources, needed by the wpsite helm chart with:
```bash
helm repo add stable https://kubernetes-charts.storage.googleapis.com
helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
helm repo add bitnami https://charts.bitnami.com/bitnami
kubectl create namespace helm-system
helm upgrade metrics-server stable/metrics-server --values kubernetes/values/metrics-server.yaml --namespace helm-system
helm install aws-alb-ingress-controller incubator/aws-alb-ingress-controller --values kubernetes/values/aws-alb-ingress-controller.yaml --namespace helm-system
helm install efs-provisioner stable/efs-provisioner --values kubernetes/values/efs-provisioner.yaml --namespace helm-system
helm install external-dns bitnami/external-dns --values kubernetes/values/external-dns.yaml --namespace helm-system
```

Finally, install the wpsite helm chart (after reviewing the values at ```kubernetes/values/wpsite.yaml```):
```bash
helm dependency update ./kubernetes/charts/wpsite/
helm install mywpsite ./kubernetes/charts/wpsite/ --values ./kubernetes/values/wpsite.yaml
```
