# wpsite EKS cluster

Add repositories for system resorces needed clustewise with:

```bash
helm repo add stable https://kubernetes-charts.storage.googleapis.com
helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
helm repo add bitnami https://charts.bitnami.com/bitnami
```

Install the required helm system charts with:
```bash
kubectl create namespace helm-system
helm install aws-alb-ingress-controller incubator/aws-alb-ingress-controller --values values/aws-alb-ingress-controller.yaml --namespace helm-system
helm install efs-provisioner stable/efs-provisioner --values values/efs-provisioner.yaml --namespace helm-system
helm install external-dns bitnami/external-dns --values values/external-dns.yaml --namespace helm-system #required if ingress.dns.enabled: true
```

Now you can install the wpsite chart with:
```bash
helm dependency update wpsite
helm install mywpsite ./wpsite --values values/wpsite.yaml
```
