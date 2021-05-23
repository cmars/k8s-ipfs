#!/bin/sh
set -e
set -x
# This is a custom entrypoint for k8s designed to run ipfs nodes in an appropriate
# setup for production scenarios.

if [ -e /data/ipfs/config ]; then
  if [ -f /data/ipfs/repo.lock ]; then
    rm /data/ipfs/repo.lock
  fi
else
  ipfs init --profile=badgerds,server
fi
ipfs config Addresses.API /ip4/0.0.0.0/tcp/5001
ipfs config Addresses.Gateway /ip4/0.0.0.0/tcp/8080
ipfs config --json Swarm.ConnMgr.HighWater 2000
ipfs config --json Datastore.BloomFilterSize 1048576
ipfs config --json API.HTTPHeaders.Access-Control-Allow-Origin '["http://'$IPFS_PUBLIC_HOST'", "http://localhost:3000", "http://127.0.0.1:5001", "https://webui.ipfs.io"]'
ipfs config --json API.HTTPHeaders.Access-Control-Allow-Methods '["PUT", "POST"]'
