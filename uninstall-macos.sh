#!/bin/bash

function uninstall_ipfs_autoload() {
  if [ -e ~/Library/LaunchAgents/ipfs-daemon.plist ]; then
    echo "Uninstalling IPFS autoloader..."

    # Unload launch agent
    launchctl unload ~/Library/LaunchAgents/ipfs-daemon.plist

    # Remove plist file
    rm ~/Library/LaunchAgents/ipfs-daemon.plist
  else
    echo "IPFS autoloader not found, skipping."
  fi
}

function uninstall_ipfs() {
  if [ -e /usr/local/bin/ipfs ]; then
    echo "Uninstalling IPFS..."

    # Remove IPFS binary
    rm /usr/local/bin/ipfs

    # Remove IPFS data directory
    rm -rf ~/.ipfs
  else
    echo "IPFS not found, skipping."
  fi
}

function uninstall_ipfs_cluster_follow_autoload() {
  if [ -e ~/Library/LaunchAgents/ipfs-cluster-follow.plist ]; then
    echo "Uninstalling IPFS Cluster Follow autoloader..."

    # Unload launch agent
    launchctl unload ~/Library/LaunchAgents/ipfs-cluster-follow.plist

    # Remove plist file
    rm ~/Library/LaunchAgents/ipfs-cluster-follow.plist
  else
    echo "IPFS Cluster Follow autoloader not found, skipping."
  fi
}

function uninstall_ipfs_cluster_follow() {
  if [ -e /usr/local/bin/ipfs-cluster-follow ]; then
    echo "Uninstalling IPFS Cluster Follow..."

    # Remove IPFS Cluster Follow binary
    rm /usr/local/bin/ipfs-cluster-follow

    # Remove IPFS Cluster Follow data directory
    rm -rf ~/.ipfs-cluster-follow
  else
    echo "IPFS Cluster Follow not found, skipping."
  fi
}

# Uninstall autoloaders and executables for IPFS and IPFS Cluster Follow independently
uninstall_ipfs_autoload
uninstall_ipfs
uninstall_ipfs_cluster_follow_autoload
uninstall_ipfs_cluster_follow

echo "IPFS and IPFS Cluster Follow have been uninstalled successfully."
