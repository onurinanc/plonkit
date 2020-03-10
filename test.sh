#!/bin/sh

set -e

if [ ! -f params.bin ]; then
    echo "Please run phase2 to generate params.bin file and copy it here"
    exit 1
fi

npx circom

# Export proving and verifying keys compatible with snarkjs and websnark
echo "Generating dummy key files..."
npx snarkjs setup --protocol groth # create dummy keys in circom format
cargo run --release export-keys # generate resulting keys

# generate solidity verifier
cargo run --release generate-verifier

# generate and verify proof
npx snarkjs calculatewitness # witness is still generated by snarkjs
cargo run --release prove
cargo run --release verify
npx snarkjs verify --vk vk.json