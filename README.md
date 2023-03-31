# ipfs-follower

Scripts for automatic `ipfs` and `ipfs-cluster-follow` installation

## MacOS manual step-by-step installation guide

Guide: [install-macos.md](./install-macos.md)


## MacOS one-line automatic installation

Save and execute script: [install-macos.sh](install-macos.sh)

Or run it directly in your terminal:
```sh
curl https://synthetixio.github.io/ipfs-follower/install-macos.sh | bash
```

Script to uninstall `ipfs` and `ipfs-cluster-follow`: [uninstall-macos.sh](uninstall-macos.sh)
```sh
curl https://synthetixio.github.io/ipfs-follower/uninstall-macos.sh | bash
```


## Building and running Docker container

```sh
docker build -t synthetix-ipfs docker
```

```sh
docker run -d -p 8080:8080 -p 5001:5001 -p 9094:9094 synthetix-ipfs
```
