# k8s-snapshot.ps1
# Gerencia snapshot do cluster Kubernetes local com Vagrant

$vmNames = @("k8s-master", "k8s-node1", "k8s-node2")
$snapshotName = "k8s-initial"

function Create-Snapshot {
    Write-Host "`n[+] Criando snapshot inicial do cluster K8s..." -ForegroundColor Green
    foreach ($vm in $vmNames) {
        Write-Host " - Criando snapshot da VM: $vm"
        vagrant snapshot save $vm $snapshotName --force
    }
    Write-Host "`n✅ Snapshot criado com sucesso!" -ForegroundColor Green
}

function Restore-Snapshot {
    Write-Host "`n[!] Restaurando snapshot do cluster K8s..." -ForegroundColor Yellow
    foreach ($vm in $vmNames) {
        Write-Host " - Restaurando snapshot da VM: $vm"
        vagrant snapshot restore $vm $snapshotName --no-provision
    }
    Write-Host "`n✅ Snapshot restaurado com sucesso!" -ForegroundColor Green
}

function Check-Snapshot-Exists {
    foreach ($vm in $vmNames) {
        $snapshots = vagrant snapshot list $vm 2>&1
        if (-not ($snapshots -match "(?i)$snapshotName")) {
            return $false
        }
    }
    return $true
}

Write-Host "`n[ Kubernetes Snapshot Manager ]`n" -ForegroundColor Cyan

if (Check-Snapshot-Exists) {
    Write-Host "✅ Um snapshot inicial foi encontrado para todas as VMs." -ForegroundColor Green
    $resp = Read-Host "Deseja restaurar o laboratório para o ponto inicial? (s/n)"
    if ($resp -eq "s") {
        Restore-Snapshot
    } else {
        Write-Host "`n👍 Nenhuma ação executada."
    }
} else {
    Write-Host "⚠️ Nenhum snapshot inicial encontrado." -ForegroundColor Yellow
    $resp = Read-Host "Deseja criar um snapshot do ambiente atual como ponto inicial? (s/n)"
    if ($resp -eq "s") {
        Create-Snapshot
    } else {
        Write-Host "`n👍 Nenhuma ação executada."
    }
}
