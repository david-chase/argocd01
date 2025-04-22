# 1. Grab the initial admin password
$initialPassword = (kubectl -n argocd get secret argocd-initial-admin-secret `
  -o jsonpath="{.data.password}" | base64 --decode)

# 2. Log in (use --insecure to skip cert checks on localhost)
argocd login localhost:8080 `
  --username admin `
  --password $initialPassword `
  --insecure
