#!/usr/bin/env bash
set -euo pipefail

internal_hosts=(argo.techtalk.com graf.techtalk.com prom.techtalk.com alm.techtalk.com k8s.techtalk.com)
external_hosts=(techtalk.techtalk.com)

lb_name=$(kubectl get svc -n shared-services ingress-nginx -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
lb_ip=$(host ${lb_name} | head -1 | awk '{print $4}')

lb_external_name=$(kubectl get svc -n shared-services ingress-nginx-external -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
lb_external_ip=$(host ${lb_external_name} | head -1 | awk '{print $4}')

for i in ${internal_hosts[@]}
do
echo "${lb_ip} ${i}"
done

for i in ${external_hosts[@]}
do
echo "${lb_external_ip} ${i}"
done