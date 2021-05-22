#!/bin/bash
set -eu
cd $(dirname $0)/..

umask 077
[ -f secrets/cluster-secret ] || (
	head -c 32 /dev/urandom | base64 -w0 > secrets/cluster-secret
)

[ -f secrets/
(cd ipfs-key; docker build -t ipfs-key .)
docker run --rm ipfs-key --type ed25519
