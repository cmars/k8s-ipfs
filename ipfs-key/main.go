package main

import (
	"encoding/json"
	"log"
	"os"

	ci "github.com/libp2p/go-libp2p-core/crypto"
	peer "github.com/libp2p/go-libp2p-core/peer"
)

func main() {
	priv, pub, err := ci.GenerateKeyPair(ci.Ed25519, -1)
	if err != nil {
		log.Fatal(err)
	}

	pid, err := peer.IDFromPublicKey(pub)
	if err != nil {
		log.Fatal(err)
	}

	var resp struct {
		PublicKey  []byte
		PrivateKey []byte
		ID         string
	}
	resp.PublicKey, err = pub.Bytes()
	if err != nil {
		log.Fatal(err)
	}
	resp.PrivateKey, err = priv.Bytes()
	if err != nil {
		log.Fatal(err)
	}
	resp.ID = pid.Pretty()

	enc := json.NewEncoder(os.Stdout)
	enc.SetIndent("", "\t")
	err = enc.Encode(&resp)
	if err != nil {
		log.Fatal(err)
	}
}
