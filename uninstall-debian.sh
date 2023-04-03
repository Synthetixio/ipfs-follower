#!/bin/bash

function uninstall_ipfs_autoload() {
  echo "Uninstalling IPFS autoload..."

  # Stop the IPFS service
  sudo systemctl stop ipfs-daemon

  # Disable and remove the IPFS service
  sudo systemctl disable ipfs-daemon
  sudo rm /etc/systemd/system/ipfs-daemon.service

  # Reload systemd configuration
  sudo systemctl daemon-reload

  echo "IPFS autoload has been uninstalled successfully."
}

function uninstall_ipfs() {
  echo "Uninstalling IPFS..."

  # Remove the IPFS binary
  sudo rm /usr/local/bin/ipfs

  # Remove the IPFS configuration directory
  rm -rf ~/.ipfs

  echo "IPFS has been uninstalled successfully."
}

function uninstall_ipfs_cluster_follow_autoload() {
  echo "Uninstalling ipfs-cluster-follow autoload..."

  # Stop the ipfs-cluster-follow service
  sudo systemctl stop ipfs-cluster-follow

  # Disable and remove the ipfs-cluster-follow service
  sudo systemctl disable ipfs-cluster-follow
  sudo rm /etc/systemd/system/ipfs-cluster-follow.service

  # Reload systemd configuration
  sudo systemctl daemon-reload

  echo "ipfs-cluster-follow autoload has been uninstalled successfully."
}

function uninstall_ipfs_cluster_follow() {
  echo "Uninstalling ipfs-cluster-follow..."

  # Remove the ipfs-cluster-follow binary
  sudo rm /usr/local/bin/ipfs-cluster-follow

  # Remove the ipfs-cluster-follow configuration directory
  rm -rf ~/.ipfs-cluster-follow

  echo "ipfs-cluster-follow has been uninstalled successfully."
}

uninstall_ipfs_autoload
uninstall_ipfs
uninstall_ipfs_cluster_follow_autoload
uninstall_ipfs_cluster_follow

echo "IPFS and ipfs-cluster-follow have been uninstalled successfully."
