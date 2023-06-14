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

echo "Configuring ipfs-cluster-follow..."

# Initialize ipfs-cluster-follow
ipfs-cluster-follow synthetix init "http://127.0.0.1:8080/ipns/k51qzi5uqu5dj0vqsuc4wyyj93tpaurdfjtulpx0w45q8eqd7uay49zodimyh7"
ipfs-cluster-follow synthetix config api.restapi.http_listen_multiaddress /ip4/0.0.0.0/tcp/9094

echo "ipfs-cluster-follow has been configured successfully."
