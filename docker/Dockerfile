# Use the latest Debian image as the base
FROM debian:latest

# Expose ipfs and ipfs-cluster-follow API ports
EXPOSE 8080
EXPOSE 5001
EXPOSE 9094

# Start ipfs and ipfs-cluster-follow
CMD ["sh", "-c", "ipfs daemon & ipfs-cluster-follow synthetix run"]

# Update the system and install required dependencies
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y curl wget gnupg sudo

# Install IPFS
COPY install_ipfs.sh /
RUN chmod +x /install_ipfs.sh && /install_ipfs.sh && rm /install_ipfs.sh

# Install ipfs-cluster-follow
COPY install_ipfs_cluster_follow.sh /
RUN chmod +x /install_ipfs_cluster_follow.sh && /install_ipfs_cluster_follow.sh && rm /install_ipfs_cluster_follow.sh
