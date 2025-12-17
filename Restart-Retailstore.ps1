param (
    [string[]] $Namespaces = @(
        "retailstore-hilim",
        "retailstore-hireq",
        "retailstore-loreq",
        "retailstore-lolim",
        "retailstore-unspecified"
    )
)

Write-Host ""
Write-Host "::: Restart-Retailstore-Workloads :::" -ForegroundColor Cyan
Write-Host ""

foreach ( $Namespace in $Namespaces ) {

    Write-Host "Restarting workloads in namespace: $Namespace" -ForegroundColor Yellow

    # Restart all Deployments in the namespace
    kubectl rollout restart deployment `
        --namespace $Namespace

    # Restart all StatefulSets in the namespace
    kubectl rollout restart statefulset `
        --namespace $Namespace

    Write-Host "Completed restarts for namespace: $Namespace"
    Write-Host ""

} # END foreach ( $Namespace in $Namespaces )

Write-Host "All Deployments and StatefulSets have been restarted." -ForegroundColor Green
Write-Host ""