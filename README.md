# aws-eks-quickstart
Batteries included AWS EKS setup

## Provision infrastructure
Infrastructure is provisioned through a bunch of terraform modules

[terraform](terraform)

After your cluster has been provisioned download your cluster kubeconfig
```bash
aws eks --region us-east-1 update-kubeconfig --name engineering
kubectl cluster-info
```

## Installing argocd
Install argocd via the helm chart

[argocd](argocd)

## Installing core-services && prometheus && tech-talk application
Installation via the argocd applications manifests

[cluster-deployments](cluster-deployments)
