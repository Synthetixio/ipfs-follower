# Synthetix Ecosystem IPFS Cluster Follower

The Synthetix ecosystem has been progressively moving towards reliance on ENS/IPFS over DNS/HTTP for web hosting. For example, Kwenta is available via [eth.limo](http://eth.limo) at [kwenta.eth.limo](https://kwenta.eth.limo/), and you can access it directly in [Brave](https://brave.com/) at [kwenta.eth](http://kwenta.eth/). Synthetix’s Core Contributors are also using IPFS to store and share protocol deployment data using [Cannon](https://usecannon.com).

The Synthetix ecosystem has created an [IPFS Cluster](https://ipfscluster.io/) to coordinate pinning these files.

You can support greater decentralization, reliability, performance, and censorship-resistance by running an IPFS node that follows the cluster. When using a pinned front-end, it will also load faster (as you’ll have the latest version available locally).

Anyone with a computer and an internet connection can join the swarm. It’s fine if you don’t have 100% uptime. 

*If you are involved in the Synthetix ecosystem and interested in pinning web apps (or any other data) in the cluster, start a discussion in the #dev-portal channel in the [Synthetix Discord server](https://discord.com/invite/AEdUHzt). Also, check out the [ipfs-deploy repository](https://github.com/Synthetixio/ipfs-deploy).*

## Installation

The scripts below will install [IPFS](https://ipfs.tech/) and [IPFS Cluster](https://ipfscluster.io/). The scripts will also configure IPFS to run in the background when you start your computer, automatically pinning the files in the Synthetix Ecosystem IPFS Cluster.

### MacOS

Run this command to use the [install-macos.sh](install-macos.sh) script:
```sh
curl https://synthetixio.github.io/ipfs-follower/install-macos.sh | bash
```

This can be uninstalled using [uninstall-macos.sh](uninstall-macos.sh):
```sh
curl https://synthetixio.github.io/ipfs-follower/uninstall-macos.sh | bash
```

If you would prefer to install manually, [follow these instructions](./install-macos.md).

### Docker

To build and run a Docker container, use the following commands:

```sh
docker build -t synthetix-ipfs docker
docker run -d -p 8080:8080 -p 5001:5001 -p 9094:9094 synthetix-ipfs
```

### Debian

Run this command to use the [install-debian.sh](install-debian.sh) script:
```sh
curl https://synthetixio.github.io/ipfs-follower/install-debian.sh | bash
```

This can be uninstalled using [uninstall-debian.sh](uninstall-debian.sh):
```sh
curl https://synthetixio.github.io/ipfs-follower/uninstall-debian.sh | bash
```

### Windows

*Coming soon.*
