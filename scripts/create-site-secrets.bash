#!/bin/bash
set -euo pipefail
cd $(dirname $0)/..

umask 077
mkdir -p secrets
[ -f secrets/basic-auth ] || (
	PASSWORD=$(head -c 16 /dev/urandom | base64 -w0)
	echo $PASSWORD > secrets/ipfs-password
	htpasswd -bc secrets/basic-auth ipfs "$PASSWORD"
)
