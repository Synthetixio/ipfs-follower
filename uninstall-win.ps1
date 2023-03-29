function Remove-IPFSScheduledTask {
  Write-Host "Removing IPFS scheduled task..."

  $ipfsTaskName = "IPFS Daemon"

  if (Get-ScheduledTask -TaskName $ipfsTaskName -ErrorAction SilentlyContinue) {
    Unregister-ScheduledTask -TaskName $ipfsTaskName -Confirm:$false
    Write-Host "IPFS scheduled task removed."
  } else {
    Write-Host "IPFS scheduled task not found."
  }
}

function Remove-IPFSClusterFollowScheduledTask {
  Write-Host "Removing IPFS Cluster Follow scheduled task..."

  $ipfsClusterTaskName = "IPFS Cluster Follow"

  if (Get-ScheduledTask -TaskName $ipfsClusterTaskName -ErrorAction SilentlyContinue) {
    Unregister-ScheduledTask -TaskName $ipfsClusterTaskName -Confirm:$false
    Write-Host "IPFS Cluster Follow scheduled task removed."
  } else {
    Write-Host "IPFS Cluster Follow scheduled task not found."
  }
}

function Uninstall-IPFS {
  Write-Host "Uninstalling IPFS..."

  $ipfsPath = "$env:LOCALAPPDATA\go-ipfs"
  if (Test-Path $ipfsExePath) {
    Remove-Item -Recurse -Force $ipfsPath
    Write-Host "IPFS uninstalled."
  } else {
    Write-Host "IPFS not found."
  }

  $ipfsSettingsPath = "$env:USERPROFILE\.ipfs"
  if (Test-Path $ipfsSettingsPath) {
    Remove-Item -Recurse -Force $ipfsSettingsPath
    Write-Host "IPFS Settings removed."
  } else {
    Write-Host "IPFS Settings not found."
  }
}

function Uninstall-IPFSClusterFollow {
  Write-Host "Uninstalling IPFS Cluster Follow..."

  $ipfsClusterFollowExePath = "$env:LOCALAPPDATA\ipfs-cluster-follow\ipfs-cluster-follow.exe"



  $ipfsClusterFollowPath = "$env:LOCALAPPDATA\ipfs-cluster-follow"
  if (Test-Path $ipfsClusterFollowPath) {
    Remove-Item -Recurse -Force $ipfsClusterFollowPath
    Write-Host "IPFS Cluster Follow uninstalled."
  } else {
    Write-Host "IPFS Cluster Follow not found."
  }

  $ipfsClusterFollowSettingsPath = "$env:USERPROFILE\.ipfs-cluster-follow"
  if (Test-Path $ipfsClusterFollowSettingsPath) {
    Remove-Item -Recurse -Force $ipfsClusterFollowSettingsPath
    Write-Host "IPFS Cluster Follow Settings removed."
  } else {
    Write-Host "IPFS Cluster Follow Settings not found."
  }
}

Remove-IPFSClusterFollowScheduledTask
Uninstall-IPFSClusterFollow

Remove-IPFSScheduledTask
Uninstall-IPFS

Write-Host "IPFS and IPFS Cluster Follow have been uninstalled successfully."
