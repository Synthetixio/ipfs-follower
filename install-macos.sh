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
  echo "Checking for existing ipfs installation..."

  # Get the latest version
  VERSIONS_URL="https://dist.ipfs.tech/go-ipfs/versions"
  LATEST_VERSION=$(curl -sSL $VERSIONS_URL | tail -n 1)
  LATEST_VERSION_NUMBER=${LATEST_VERSION#*v}

  # Check if ipfs is already installed
  if command -v ipfs &> /dev/null; then
    INSTALLED_VERSION=$(ipfs --version | awk '{print $3}')

    if [ "$INSTALLED_VERSION" == "$LATEST_VERSION_NUMBER" ]; then
      echo "ipfs version $INSTALLED_VERSION is already installed."
      return
    else
      echo "Updating ipfs from version $INSTALLED_VERSION to $LATEST_VERSION_NUMBER"
    fi
  else
    echo "Installing ipfs version $LATEST_VERSION_NUMBER"
  fi

  # Download the latest version
  DOWNLOAD_URL="https://dist.ipfs.tech/go-ipfs/${LATEST_VERSION}/go-ipfs_${LATEST_VERSION}_darwin-${ARCH}.tar.gz"
  echo "DOWNLOAD_URL=$DOWNLOAD_URL"
  curl -sSL -o ipfs.tar.gz $DOWNLOAD_URL

  # Extract the binary
  tar -xzf ipfs.tar.gz
  rm ipfs.tar.gz

  # Move the binary to /usr/local/bin or another directory in your $PATH
  mv ./go-ipfs/ipfs /usr/local/bin/
  rm -r ./go-ipfs

  # Check if the installation was successful
  if ipfs --version | grep -q "ipfs version"; then
    echo "ipfs version $(ipfs --version | awk '{print $3}') installed successfully."
  else
    echo "Installation failed."
    exit 1
  fi
}

function configure_ipfs() {
  echo "Configuring IPFS..."

  ipfs init
  ipfs config --json API.HTTPHeaders.Access-Control-Allow-Origin '["*"]' &> /dev/null;
  ipfs config --json API.HTTPHeaders.Access-Control-Allow-Methods '["PUT", "POST", "GET"]' &> /dev/null;
  ipfs config profile apply lowpower &> /dev/null;
}

function install_ipfs_autoload() {
  echo "Installing IPFS autoloader..."

  # Create plist file for ipfs-daemon to autostart on login
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

  # Check if ipfs-daemon is already loaded
  if launchctl list | grep -q "ipfs-daemon"; then
    echo "Unloading existing ipfs-daemon service..."
    launchctl unload ~/Library/LaunchAgents/ipfs-daemon.plist
  fi

  # Load and start ipfs-daemon service
  echo "Loading ipfs-daemon service..."
  launchctl load -w ~/Library/LaunchAgents/ipfs-daemon.plist

  echo "ipfs-daemon autoloader has been installed successfully."
}

function install_ipfs_cluster_follow() {
  echo "Checking for existing ipfs-cluster-follow installation..."

  # Get the latest version of ipfs-cluster-follow
  VERSIONS_URL="https://dist.ipfs.tech/ipfs-cluster-follow/versions"
  LATEST_VERSION=$(curl -sSL $VERSIONS_URL | tail -n 1)
  LATEST_VERSION_NUMBER=${LATEST_VERSION#*v}

  # Check if ipfs-cluster-follow is already installed
  if command -v ipfs-cluster-follow &> /dev/null; then
    INSTALLED_VERSION=$(ipfs-cluster-follow --version | awk '{print $3}')

    if [ "$INSTALLED_VERSION" == "$LATEST_VERSION_NUMBER" ]; then
      echo "ipfs-cluster-follow version $INSTALLED_VERSION is already installed."
      return
    else
      echo "Updating ipfs-cluster-follow from version $INSTALLED_VERSION to $LATEST_VERSION_NUMBER"
    fi
  else
    echo "Installing ipfs-cluster-follow version $LATEST_VERSION_NUMBER"
  fi

  # Download the latest version
  DOWNLOAD_URL="https://dist.ipfs.tech/ipfs-cluster-follow/${LATEST_VERSION}/ipfs-cluster-follow_${LATEST_VERSION}_darwin-${ARCH}.tar.gz"
  echo "DOWNLOAD_URL=$DOWNLOAD_URL"
  curl -sSL -o ipfs-cluster-follow.tar.gz $DOWNLOAD_URL

  # Extract the binary
  tar -xzf ipfs-cluster-follow.tar.gz
  rm ipfs-cluster-follow.tar.gz

  # Move the binary to /usr/local/bin or another directory in your $PATH
  mv ipfs-cluster-follow/ipfs-cluster-follow /usr/local/bin/
  rm -r ipfs-cluster-follow

  # Check if the installation was successful
  if ipfs-cluster-follow --version | grep -q "ipfs-cluster-follow version"; then
    echo "ipfs-cluster-follow version $(ipfs-cluster-follow --version | awk '{print $4}') installed successfully."
  else
    echo "Installation failed."
    exit 1
  fi
}

function configure_ipfs_cluster_follow() {
  echo "Configuring ipfs-cluster-follow..."

  # Initialize ipfs-cluster-follow
  ipfs-cluster-follow synthetix init "http://127.0.0.1:8080/ipns/k51qzi5uqu5dj0vqsuc4wyyj93tpaurdfjtulpx0w45q8eqd7uay49zodimyh7"

  echo "ipfs-cluster-follow has been configured successfully."
}

function install_ipfs_cluster_follow_autoload() {
  echo "Installing ipfs-cluster-follow autoloader..."

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


  # Check if ipfs-daemon is already loaded
  if launchctl list | grep -q "ipfs-cluster-follow"; then
    echo "Unloading existing ipfs-cluster-follow service..."
    launchctl unload ~/Library/LaunchAgents/ipfs-cluster-follow.plist
  fi

  # Load and start ipfs-daemon service
  echo "Loading ipfs-cluster-follow service..."
  launchctl load -w ~/Library/LaunchAgents/ipfs-cluster-follow.plist

  echo "ipfs-cluster-follow autoloader has been installed successfully."
}

install_ipfs
configure_ipfs
install_ipfs_autoload

install_ipfs_cluster_follow
configure_ipfs_cluster_follow
install_ipfs_cluster_follow_autoload

echo "IPFS and ipfs-cluster-follow have been installed and configured successfully."
