# aws-eks-quickstart
Batteries included AWS EKS setup

## Provision infrastructure
Infrastructure is provisioned through a bunch of terraform modules. 

## Bootstrapping argocd
Install argocd via the helm chart [argocd](argocd)

## Bootstrapping core-services and prometheus stack
Install both stacks via the argocd applications manifests [cluster-deployments](cluster-deployments)