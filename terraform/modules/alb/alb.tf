/* 
Public L7 alb in front of ingress-nginx.
Uses aws waf security automations for waf.
Target group is added in the worker node ASG pointed to the ingress-nginx external nodeport.
*/