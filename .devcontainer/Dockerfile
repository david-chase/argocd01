FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04

# Avoid prompts
ENV DEBIAN_FRONTEND=noninteractive

# Core packages
RUN apt-get update && apt-get install -y \
    curl \
    ca-certificates \
    gnupg \
    lsb-release \
    jq \
    git \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# ---- kubectl ----
RUN curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.33/deb/Release.key \
    | gpg --dearmor -o /usr/share/keyrings/kubernetes-archive-keyring.gpg \
 && echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.33/deb/ /" \
    | tee /etc/apt/sources.list.d/kubernetes.list \
 && apt-get update \
 && apt-get install -y kubectl

# ---- Helm ----
RUN curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# ---- Kustomize ----
RUN curl -s https://api.github.com/repos/kubernetes-sigs/kustomize/releases/latest \
 | jq -r '.assets[] | select(.name | test("linux_amd64")) | .browser_download_url' \
 | xargs curl -L -o /tmp/kustomize.tar.gz \
 && tar -xzf /tmp/kustomize.tar.gz -C /usr/local/bin \
 && rm /tmp/kustomize.tar.gz

# ---- Argo CD CLI ----
RUN curl -sSL -o /usr/local/bin/argocd \
    https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64 \
 && chmod +x /usr/local/bin/argocd

# ---- PowerShell ----
RUN apt-get update && apt-get install -y powershell

# Default shell
SHELL ["/usr/bin/pwsh", "-Command"]
