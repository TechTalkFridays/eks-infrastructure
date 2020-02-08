# Argocd installation
https://github.com/argoproj/argo-cd

## Installing argocd
Create a new directory of variables in helm_vars

Now we can run the installation.
```bash
helm install argocd . -f helm_vars/morty/values.yaml
```

To redeploy argocd with updated configs run:
```bash
helm upgrade argocd . -f helm_vars/morty/values.yaml
```

Install shared-service and kube-prometheus app of apps
```bash
kubectl apply -f app-of-apps/morty/
```

Create a DNS record for the argo cd UI.

## Adding new clusters
Registers a cluster's credentials to Argo CD, and is only necessary when deploying to an external cluster. When deploying internally (to the same cluster that Argo CD is running in), https://kubernetes.default.svc should be used as the application's K8s API server address.

```bash
argocd cluster add rick
```

## Adding new apps
Configure and kubectl apply an application spec.  
https://argoproj.github.io/argo-cd/operator-manual/application.yaml

Otherwise:
```bash
argocd app create guestbook \
  --repo https://github.com/argoproj/argocd-example-apps.git \
  --path guestbook \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace default
  --grpc-web
```

## Adding new projects
Configure and kubectl apply a project spec.  
https://argoproj.github.io/argo-cd/operator-manual/project.yaml

Otherwise:
```bash
argocd proj create example-project \
  --grpc-web
```
