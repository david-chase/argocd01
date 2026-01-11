helm upgrade --install kubex-automation-controller densify/kubex-automation-controller `
  --namespace kubex `
  --create-namespace `
  -f kubex-automation-values.yaml