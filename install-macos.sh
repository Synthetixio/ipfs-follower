#!/bin/bash

# Determine macOS architecture
ARCH=$(uname -m)

# Check if the system is running on ARM or x86_64 architecture
if [ "$ARCH" = "arm64" ]; then
  ARCH="arm64"
elif [ "$ARCH" = "x86_64" ]; then
  ARCH="amd64"
else
  echo "Unsupported architecture."
  exit 1
fi

function install_ipfs() {
  echo Install go-ipfs

  echo Get the latest version
  VERSIONS_URL="https://dist.ipfs.tech/go-ipfs/versions"
  LATEST_VERSION=$(curl -SL $VERSIONS_URL | tail -n 1)
  echo LATEST_VERSION=$LATEST_VERSION
  
  echo Download the latest version
  DOWNLOAD_URL="https://dist.ipfs.tech/go-ipfs/${LATEST_VERSION}/go-ipfs_${LATEST_VERSION}_darwin-${ARCH}.tar.gz"
  echo DOWNLOAD_URL=$DOWNLOAD_URL
  curl -SL -o ipfs.tar.gz $DOWNLOAD_URL
  
  # Extract the binary
  tar -xzf ipfs.tar.gz
  rm ipfs.tar.gz
  
  # Move the binary to /usr/local/bin or another directory in your $PATH
  mv ipfs/ipfs /usr/local/bin/
  rm -r ipfs
  
  # Check if the installation was successful
  if ipfs --version | grep -q "ipfs version"; then
    echo "$(ipfs --version) installed successfully."
  else
    echo "Installation failed."
    exit 1
  fi
}


function install_ipfs_cluster_follow() {
  # Get the latest version of ipfs-cluster-follow
  VERSIONS_URL="https://dist.ipfs.tech/ipfs-cluster-follow/versions"
  LATEST_VERSION=$(curl -sSL $VERSIONS_URL | tail -n 1)
  
  # Download the latest version
  DOWNLOAD_URL="https://dist.ipfs.tech/ipfs-cluster-follow/${LATEST_VERSION}/ipfs-cluster-follow_${LATEST_VERSION}_darwin-${ARCH}.tar.gz"
  curl -sSL -o ipfs-cluster-follow.tar.gz $DOWNLOAD_URL
  
  # Extract the binary
  tar -xzf ipfs-cluster-follow.tar.gz
  rm ipfs-cluster-follow.tar.gz
  
  # Move the binary to /usr/local/bin or another directory in your $PATH
  mv ipfs-cluster-follow/ipfs-cluster-follow /usr/local/bin/
  rm -r ipfs-cluster-follow
  
  # Check if the installation was successful
  if ipfs-cluster-follow --version | grep -q "ipfs-cluster-follow version"; then
    echo "$(ipfs-cluster-follow --version) installed successfully."
  else
    echo "Installation failed."
    exit 1
  fi
}


install_ipfs

# Initialize and configure IPFS
ipfs init
ipfs config --json API.HTTPHeaders.Access-Control-Allow-Origin '["*"]'
ipfs config --json API.HTTPHeaders.Access-Control-Allow-Methods '["PUT", "POST", "GET"]'
ipfs config profile apply lowpower

# TODO: uncomment if needed, but we don't need this
# Download and install IPFS Desktop App
#  curl -L https://github.com/ipfs-shipyard/ipfs-desktop/releases/latest/download/ipfs-desktop.dmg -o ipfs-desktop.dmg
#  hdiutil attach ipfs-desktop.dmg
#  cp -R /Volumes/IPFS\ Desktop/IPFS\ Desktop.app /Applications
#  hdiutil detach /Volumes/IPFS\ Desktop

install_ipfs_cluster_follow

# Initialize ipfs-cluster-follow
ipfs-cluster-follow synthetix init "http://127.0.0.1:8080/ipns/k51qzi5uqu5dmdzyb1begj16z2v5btbyzo1lnkdph0kn84o9gmc2uokpi4w54c"

# Create plist file for ipfs-cluster-follow to autostart on login
cat > ~/Library/LaunchAgents/ipfs-daemon.plist <<- EOM
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key>
    <string>ipfs-daemon</string>
    <key>ProgramArguments</key>
    <array>
      <string>/usr/local/bin/ipfs</string>
      <string>daemon</string>
      <string>--init</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
    <key>StandardErrorPath</key>
    <string>/tmp/ipfs-daemon.err</string>
    <key>StandardOutPath</key>
    <string>/tmp/ipfs-daemon.out</string>
  </dict>
</plist>
EOM

# Load and start ipfs-daemon service
launchctl load -w ~/Library/LaunchAgents/ipfs-daemon.plist


# Create plist file for ipfs-cluster-follow to autostart on login
cat > ~/Library/LaunchAgents/ipfs-cluster-follow.plist <<- EOM
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key>
    <string>ipfs-cluster-follow</string>
    <key>ProgramArguments</key>
    <array>
      <string>/usr/local/bin/ipfs-cluster-follow</string>
      <string>synthetix</string>
      <string>run</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
    <key>StandardErrorPath</key>
    <string>/tmp/ipfs-cluster-follow.err</string>
    <key>StandardOutPath</key>
    <string>/tmp/ipfs-cluster-follow.out</string>
  </dict>
</plist>
EOM

# Load and start ipfs-cluster-follow service
launchctl load -w ~/Library/LaunchAgents/ipfs-cluster-follow.plist

echo "IPFS and ipfs-cluster-follow have been installed and configured successfully."
