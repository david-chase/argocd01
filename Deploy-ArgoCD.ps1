# Download the latest Argocd CLI binary
Invoke-WebRequest -Uri "https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64" -OutFile argocd-linux-amd64

# Make it executable and move into your PATH
sudo chmod 555 argocd-linux-amd64
sudo mv argocd-linux-amd64 /usr/local/bin/argocd

# Install Argo CD core components
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

Write-Host "Waiting 20 seconds for pods to start" -Foregroundcolor Green
Start-Sleep -Seconds 20


# Port forward
Start-Process pwsh -ArgumentList '-NoExit', '-Command', 'kubectl port-forward svc/argocd-server -n argocd 8080:443'

# 1. Grab the initial admin password
$initialPassword = (kubectl -n argocd get secret argocd-initial-admin-secret `
  -o jsonpath="{.data.password}" | base64 --decode)

# 2. Log in (use --insecure to skip cert checks on localhost)
argocd login localhost:8080 `
  --username admin `
  --password $initialPassword `
  --insecure

kubectl apply -f tokyo/app-of-apps.yaml