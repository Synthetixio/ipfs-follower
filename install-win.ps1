# install-win.ps1

# Determine Windows architecture
$ARCH = (Get-WmiObject -Class Win32_OperatingSystem).OSArchitecture

# Check if the system is running on ARM or x86_64 architecture
if ($ARCH -eq "ARM64") {
  $ARCH = "arm64"
} elseif ($ARCH -eq "64-bit") {
  $ARCH = "amd64"
} else {
  Write-Host "Unsupported architecture."
  exit 1
}



function Install-IPFS {
  Write-Host "Checking for existing ipfs installation..."

  # Get the latest version of ipfs
  $VERSIONS_URL = "https://dist.ipfs.tech/go-ipfs/versions"
  $LATEST_VERSION = (Invoke-WebRequest -Uri $VERSIONS_URL).Content.Trim() -split "`n" | Select-Object -Last 1
  $LATEST_VERSION_NUMBER = $LATEST_VERSION.TrimStart("v")


  # Check if ipfs is already installed
  $ipfsExePath = "$env:LOCALAPPDATA\ipfs\ipfs.exe"
  New-Item -ItemType Directory -Path "$env:LOCALAPPDATA\ipfs\" | Out-Null

  if (Test-Path $ipfsExePath) {
    $INSTALLED_VERSION = & $ipfsExePath --version
    $INSTALLED_VERSION_NUMBER = ($INSTALLED_VERSION -split ' ')[2]

    if ($INSTALLED_VERSION_NUMBER -eq $LATEST_VERSION_NUMBER) {
      Write-Host "ipfs version $INSTALLED_VERSION_NUMBER is already installed."
      return
    } else {
      Write-Host "Updating ipfs from version $INSTALLED_VERSION_NUMBER to $LATEST_VERSION_NUMBER"
    }
  } else {
    Write-Host "Installing ipfs version $LATEST_VERSION_NUMBER"
  }

  # Download the latest version
  $DOWNLOAD_URL = "https://dist.ipfs.tech/go-ipfs/${LATEST_VERSION}/go-ipfs_${LATEST_VERSION}_windows-${ARCH}.zip"
  Write-Host "DOWNLOAD_URL=$DOWNLOAD_URL"
  $zipPath = Join-Path $env:TEMP "ipfs.zip"
  Invoke-WebRequest -Uri $DOWNLOAD_URL -OutFile $zipPath

  # Extract the binary
  $tempFolderPath = Join-Path $env:TEMP "ipfs"
  if (Test-Path $tempFolderPath) {
    Remove-Item -Path $tempFolderPath -Recurse -Force
  }
  New-Item -ItemType Directory -Path $tempFolderPath | Out-Null
  Expand-Archive -Path $zipPath -DestinationPath $tempFolderPath
  Remove-Item -Path $zipPath

  # Move the binary to %LOCALAPPDATA%\ipfs
  $installFolderPath = "$env:LOCALAPPDATA\ipfs"
  if (-not(Test-Path $installFolderPath)) {
    New-Item -ItemType Directory -Path $installFolderPath | Out-Null
  }
  Move-Item -Path "$tempFolderPath\go-ipfs\ipfs.exe" -Destination $ipfsExePath -Force
  Remove-Item -Path $tempFolderPath -Recurse -Force

  # Check if the installation was successful
  if (& $ipfsExePath --version | Select-String -Pattern "ipfs version") {
    Write-Host "ipfs version $LATEST_VERSION_NUMBER installed successfully."
  } else {
    Write-Host "Installation failed."
    exit 1
  }
}

function Configure-IPFS {
  Write-Host "Configuring IPFS..."

  $ipfsExePath = "$env:LOCALAPPDATA\go-ipfs\ipfs.exe"
  & $ipfsExePath init
  & $ipfsExePath config --json API.HTTPHeaders.Access-Control-Allow-Origin '["*"]' > $null
  & $ipfsExePath config --json API.HTTPHeaders.Access-Control-Allow-Methods '["PUT", "POST", "GET"]' > $null
  & $ipfsExePath config profile apply lowpower > $null

  Write-Host "IPFS has been configured successfully."
}

function Install-IPFS-Autoload {
  Write-Host "Installing IPFS autoloader..."

  $ipfsExePath = "$env:LOCALAPPDATA\go-ipfs\ipfs.exe"
  $ipfsTaskName = "IPFS Daemon"

  # Check if the scheduled task already exists
  $existingTask = Get-ScheduledTask -TaskName $ipfsTaskName -ErrorAction SilentlyContinue

  if ($null -eq $existingTask) {
    # Create scheduled tasks to start IPFS on system startup
    $actionIPFS = New-ScheduledTaskAction -Execute $ipfsExePath -Argument "daemon --init"
    $trigger = New-ScheduledTaskTrigger -AtStartup
    Register-ScheduledTask -Action $actionIPFS -Trigger $trigger -TaskName $ipfsTaskName -Description "Start IPFS daemon on system startup" -User "System"
    Write-Host "IPFS autoloader has been installed successfully."
  } else {
    Write-Host "IPFS autoloader is already installed."
  }
}

function Install-IPFSClusterFollow {
  Write-Host "Checking for existing ipfs-cluster-follow installation..."

  # Get the latest version of ipfs-cluster-follow
  $VERSIONS_URL = "https://dist.ipfs.tech/ipfs-cluster-follow/versions"
  $LATEST_VERSION = (Invoke-WebRequest -Uri $VERSIONS_URL).Content.Trim() -split "`n" | Select-Object -Last 1
  $LATEST_VERSION_NUMBER = $LATEST_VERSION.TrimStart("v")


  # Check if ipfs-cluster-follow is already installed
  $clusterFollowExePath = "$env:LOCALAPPDATA\ipfs-cluster-follow\ipfs-cluster-follow.exe"
  New-Item -ItemType Directory -Path "$env:LOCALAPPDATA\ipfs-cluster-follow\" | Out-Null

  if (Test-Path $clusterFollowExePath) {
    $INSTALLED_VERSION = & $clusterFollowExePath --version | %{ $_.Split(" ")[2] }

    if ($INSTALLED_VERSION -eq $LATEST_VERSION_NUMBER) {
      Write-Host "ipfs-cluster-follow version $INSTALLED_VERSION is already installed."
      return
    } else {
      Write-Host "Updating ipfs-cluster-follow from version $INSTALLED_VERSION to $LATEST_VERSION_NUMBER"
    }
  } else {
    Write-Host "Installing ipfs-cluster-follow version $LATEST_VERSION_NUMBER"
  }

  # Download the latest version
  $DOWNLOAD_URL = "https://dist.ipfs.tech/ipfs-cluster-follow/$LATEST_VERSION/ipfs-cluster-follow_${LATEST_VERSION}_windows-${ARCH}.zip"
  Write-Host "DOWNLOAD_URL=$DOWNLOAD_URL"
  $zipPath = Join-Path $env:TEMP "ipfs-cluster-follow.zip"
  Invoke-WebRequest -Uri $DOWNLOAD_URL -OutFile $zipPath

  # Extract the binary
  $tempFolderPath = Join-Path $env:TEMP "ipfs-cluster-follow"
  if (Test-Path $tempFolderPath) {
    Remove-Item -Path $tempFolderPath -Recurse -Force
  }
  New-Item -ItemType Directory -Path $tempFolderPath | Out-Null
  Expand-Archive -Path $zipPath -DestinationPath $tempFolderPath
  Remove-Item -Path $zipPath

  # Move the binary to %LOCALAPPDATA%\ipfs-cluster-follow
  $installFolderPath = "$env:LOCALAPPDATA\ipfs-cluster-follow"
  if (-not(Test-Path $installFolderPath)) {
    New-Item -ItemType Directory -Path $installFolderPath | Out-Null
  }
  Move-Item -Path "$tempFolderPath\ipfs-cluster-follow\ipfs-cluster-follow.exe" -Destination $clusterFollowExePath -Force
  Remove-Item -Path $tempFolderPath -Recurse -Force

  # Check if the installation was successful
  if (& $clusterFollowExePath --version | Select-String -Pattern "ipfs-cluster-follow version") {
    Write-Host "ipfs-cluster-follow version $LATEST_VERSION_NUMBER installed successfully."
  } else {
    Write-Host "Installation failed."
    exit 1
  }
}

function Configure-IPFSClusterFollow {
  Write-Host "Configuring ipfs-cluster-follow..."

  # Initialize ipfs-cluster-follow
  $clusterFollowExePath = "$env:LOCALAPPDATA\ipfs-cluster-follow\ipfs-cluster-follow.exe"
  & $clusterFollowExePath synthetix init "http://127.0.0.1:8080/ipns/k51qzi5uqu5dj0vqsuc4wyyj93tpaurdfjtulpx0w45q8eqd7uay49zodimyh7"

  Write-Host "ipfs-cluster-follow has been configured successfully."
}

function Install-IPFSClusterFollow-Autoload {
  Write-Host "Installing ipfs-cluster-follow autoloader..."

  # Create scheduled tasks to start ipfs-cluster-follow on system startup
  $ipfsClusterFollowTaskName = "IPFS Cluster Follow"
  $clusterFollowExePath = "$env:LOCALAPPDATA\ipfs-cluster-follow\ipfs-cluster-follow.exe"

  # Check if the scheduled task already exists
  $existingTask = Get-ScheduledTask -TaskName $ipfsClusterFollowTaskName -ErrorAction SilentlyContinue
  if ($existingTask) {
    Write-Host "The scheduled task for ipfs-cluster-follow already exists. Skipping task creation."
  } else {
    $actionClusterFollow = New-ScheduledTaskAction -Execute $clusterFollowExePath -Argument "synthetix run"
    $trigger = New-ScheduledTaskTrigger -AtStartup
    Register-ScheduledTask -Action $actionClusterFollow -Trigger $trigger -TaskName $ipfsClusterFollowTaskName -Description "Start ipfs-cluster-follow on system startup" -User "System"

    Write-Host "ipfs-cluster-follow autoloader has been installed successfully."
  }
}

Install-IPFS
Configure-IPFS
Install-IPFS-Autoload

Install-IPFSClusterFollow
Configure-IPFSClusterFollow
Install-IPFSClusterFollow-Autoload

Write-Host "IPFS and ipfs-cluster-follow have been installed and configured successfully."
