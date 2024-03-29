#!/bin/bash

proposal_json=$1

proposal="$CHAIN_BINARY tx gov submit-proposal param-change $proposal_json --from $WALLET_1 --home $HOME_1 --gas auto --gas-adjustment $GAS_ADJUSTMENT --fees $BASE_FEES$DENOM -o json -b block -y"
echo $proposal
txhash=$($proposal | jq -r .txhash)
sleep 5
echo "Proposal hash: $txhash"
proposal_id=$($CHAIN_BINARY --output json q tx $txhash --home $HOME_1 | jq -r '.logs[].events[] | select(.type=="submit_proposal") | .attributes[] | select(.key=="proposal_id") | .value')
vote="$CHAIN_BINARY tx gov vote $proposal_id yes --from $WALLET_1 --home $HOME_1 --gas auto --gas-adjustment $GAS_ADJUSTMENT --fees $BASE_FEES$DENOM -b block -y -o json"
txhash=$($vote | jq -r .txhash)
sleep 5
echo "Vote hash: $txhash"
sleep 5