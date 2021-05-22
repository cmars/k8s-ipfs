#!/bin/bash
set -euo pipefail
cd $(dirname $0)/..

umask 077
[ -f secrets/cluster-secret ] || (
	head -c 32 /dev/urandom | base64 -w0 > secrets/cluster-secret
)

[ -f secrets/bootstrap_peer_priv_key ] || (
	(cd ipfs-key; docker build -t ipfs-key .)
	IPFS_KEY=$(docker run --rm ipfs-key)
	IPFS_PRIVATE_KEY=$(jq -r '.PrivateKey' <<< "$IPFS_KEY")
	IPFS_PUBLIC_KEY=$(jq -r '.PublicKey' <<< "$IPFS_KEY")
	IPFS_PEER_ID=$(jq -r '.ID' <<< "$IPFS_KEY")

	echo -n "${IPFS_PRIVATE_KEY}" > secrets/bootstrap_peer_priv_key
	echo -n "${IPFS_PUBLIC_KEY}" > secrets/bootstrap_peer_pub_key
	echo -n "${IPFS_PEER_ID}" > secrets/bootstrap_peer_id
)
