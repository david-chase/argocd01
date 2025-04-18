
param (
    [string]$ArgocdNamespace = "argocd"
)

Write-Host ""
Write-Host "::: Expose-Argocd-Subpath.ps1 :::" -ForegroundColor Cyan
Write-Host ""

# 0. Delete any old Ingress in both namespaces
kubectl delete ingress argocd-server-ingress -n ingress-nginx --ignore-not-found
kubectl delete ingress argocd-server-ingress -n $ArgocdNamespace --ignore-not-found

# 1. Patch Argo CD to serve under /argocd
kubectl -n $ArgocdNamespace patch configmap argocd-cmd-params-cm `
  --type merge `
  -p @'
{
  "data": {
    "server.basehref": "/argocd",
    "server.rootpath": "/argocd"
  }
}
'@

# 2. Create the Ingress in the argocd namespace so it can reference its service
$ingress = @"
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: argocd-server-ingress
  namespace: $ArgocdNamespace
  annotations:
    nginx.ingress.kubernetes.io/use-regex: "true"
    nginx.ingress.kubernetes.io/rewrite-target: /$2
    nginx.ingress.kubernetes.io/ssl-redirect: "false"
    nginx.ingress.kubernetes.io/backend-protocol: "HTTPS"
spec:
  ingressClassName: nginx
  rules:
  - host: localhost
    http:
      paths:
      - path: /argocd(/|$)(.*)
        pathType: ImplementationSpecific
        backend:
          service:
            name: argocd-server
            port:
              number: 443
"@

# 3. Apply the Ingress in argocd ns
$ingress | kubectl apply -f -

# 4. Verify
kubectl -n $ArgocdNamespace get ingress argocd-server-ingress
