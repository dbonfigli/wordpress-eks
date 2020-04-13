# wpsite

This chart is a one click stop to install a wordpress cluster composed of:
* mariadb with replica clustering, courtesy of bitnami;
* a pv and pvc for the shared efs volume where every wordpress pod will store it's "uploads" directory;
* a secret, where the whole file wp-config.php is stored;
* a deployment with nginx + php + wordpress;
* a service + ingress to expose the application.

See values.yaml to understand what parameter to use.

To use it, first update dependencies with:
```bash
helm dependency update .
```

Then create your own values.yaml file and install it with:
```bash
helm install mywpsite wpsite --values values.yaml
```