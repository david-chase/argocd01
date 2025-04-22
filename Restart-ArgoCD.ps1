# 1) Restart each core Argo CD deployment explicitly
$deployments = @(
  'argocd-server',
  'argocd-repo-server',
  'argocd-application-controller',
  'argocd-dex-server'
)

foreach ($d in $deployments) {
    kubectl -n argocd rollout restart deployment $d
}

# 2) (Optional) If you really want “restart everything” but your kubectl is too old for --all:
#    grab all deployment names and pipe them through restart
kubectl -n argocd get deployment -o name |
  ForEach-Object { kubectl -n argocd rollout restart $_ }
