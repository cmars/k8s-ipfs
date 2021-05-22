#!/bin/bash
set -euo pipefail
cd $(dirname $0)/..

umask 077
mkdir -p secrets site
[ -f secrets/cluster-secret ] || (
	head -c 32 /dev/urandom | base16 -w0 > secrets/cluster-secret
)

[ -f secrets/bootstrap-peer-priv-key ] || (
	(cd ipfs-key; docker build -t ipfs-key .)
	IPFS_KEY=$(docker run --rm ipfs-key)
	IPFS_PRIVATE_KEY=$(jq -r '.PrivateKey' <<< "$IPFS_KEY")
	IPFS_PUBLIC_KEY=$(jq -r '.PublicKey' <<< "$IPFS_KEY")
	IPFS_PEER_ID=$(jq -r '.ID' <<< "$IPFS_KEY")

	echo -n "${IPFS_PRIVATE_KEY}" > secrets/bootstrap-peer-priv-key
	echo -n "${IPFS_PUBLIC_KEY}" > site/bootstrap-peer-pub-key
	echo -n "${IPFS_PEER_ID}" > site/bootstrap-peer-id
)
