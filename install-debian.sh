#!/bin/bash

# Determine Debian architecture
ARCH=$(uname -m)

# Check if the system is running on ARM or x86_64 architecture
if [ "$ARCH" = "arm64" ]; then
  ARCH="arm64"
elif [ "$ARCH" = "x86_64" ]; then
  ARCH="amd64"
elif [ "$ARCH" = "aarch64" ]; then
  ARCH="arm64"
else
  echo "Unsupported architecture $ARCH."
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
  DOWNLOAD_URL="https://dist.ipfs.tech/go-ipfs/${LATEST_VERSION}/go-ipfs_${LATEST_VERSION}_linux-${ARCH}.tar.gz"
  echo "DOWNLOAD_URL=$DOWNLOAD_URL"
  curl -sSL -o ipfs.tar.gz $DOWNLOAD_URL

  # Extract the binary
  tar -xzf ipfs.tar.gz
  rm ipfs.tar.gz

  # Move the binary to /usr/local/bin or another directory in your $PATH
  sudo mv ./go-ipfs/ipfs /usr/local/bin/
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

  CURRENT_USER=$(whoami)

  # Create systemd service file for ipfs-daemon
  sudo bash -c "cat > /etc/systemd/system/ipfs-daemon.service <<- EOM
[Unit]
Description=IPFS daemon
After=network.target

[Service]
User=$CURRENT_USER
ExecStart=/usr/local/bin/ipfs daemon --init
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOM
"

  # Enable and start ipfs-daemon service
  sudo systemctl daemon-reload
  sudo systemctl enable ipfs-daemon
  sudo systemctl start ipfs-daemon

  echo "IPFS autoloader has been installed successfully."
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
  DOWNLOAD_URL="https://dist.ipfs.tech/ipfs-cluster-follow/${LATEST_VERSION}/ipfs-cluster-follow_${LATEST_VERSION}_linux-${ARCH}.tar.gz"
  echo "DOWNLOAD_URL=$DOWNLOAD_URL"
  curl -sSL -o ipfs-cluster-follow.tar.gz $DOWNLOAD_URL

  # Extract the binary
  tar -xzf ipfs-cluster-follow.tar.gz
  rm ipfs-cluster-follow.tar.gz

  # Move the binary to /usr/local/bin or another directory in your $PATH
  sudo mv ipfs-cluster-follow/ipfs-cluster-follow /usr/local/bin/
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
  ipfs-cluster-follow synthetix init "http://127.0.0.1:8080/ipns/k51qzi5uqu5dmdzyb1begj16z2v5btbyzo1lnkdph0kn84o9gmc2uokpi4w54c"

  echo "ipfs-cluster-follow has been configured successfully."
}

function install_ipfs_cluster_follow_autoload() {
  echo "Installing ipfs-cluster-follow autoloader..."

  CURRENT_USER=$(whoami)

  # Create systemd service file for ipfs-cluster-follow
  sudo bash -c "cat > /etc/systemd/system/ipfs-cluster-follow.service <<- EOM
[Unit]
Description=IPFS Cluster Follow daemon
Requires=ipfs-daemon.service
After=network.target ipfs-daemon.service

[Service]
User=$CURRENT_USER
Environment=IPFS_PATH=/home/$CURRENT_USER/.ipfs
WorkingDirectory=/home/$CURRENT_USER
ExecStart=/usr/local/bin/ipfs-cluster-follow synthetix run
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOM
"

  # Enable and start ipfs-cluster-follow service
  sudo systemctl daemon-reload
  sudo systemctl enable ipfs-cluster-follow
  sudo systemctl start ipfs-cluster-follow

  echo "ipfs-cluster-follow autoloader has been installed successfully."
}

install_ipfs
configure_ipfs
install_ipfs_autoload

install_ipfs_cluster_follow
configure_ipfs_cluster_follow
install_ipfs_cluster_follow_autoload

echo "IPFS and ipfs-cluster-follow have been installed and configured successfully."
