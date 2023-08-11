#!/bin/bash
# ICA delegation failure cases

echo "** Failure case 1: ICA attempts to delegate without validator bond **"
$CHAIN_BINARY q staking validator $VALOPER_3 -o json --home $HOME_1 | jq '.'
$CHAIN_BINARY q bank balances $$ICA_ADDRESS -o json --home $HOME_1 | jq '.'

jq -r --arg ADDRESS "$ICA_ADDRESS" '.delegator_address = $ADDRESS' tests/v12_upgrade/msg-delegate.json > delegate-fail.json
message=$(jq -r --arg ADDRESS "$VALOPER_3" '.validator_address = $ADDRESS' delegate-fail.json)
echo "Generating packet JSON..."
$STRIDE_CHAIN_BINARY tx interchain-accounts host generate-packet-data "$message" > delegate_packet.json
echo "Sending tx staking delegate to host chain..."
submit_ibc_tx "tx interchain-accounts controller send-tx connection-0 delegate_packet.json --from $STRIDE_WALLET_1 --chain-id $STRIDE_CHAIN_ID --gas auto --fees $BASE_FEES$STRIDE_DENOM --gas-adjustment $GAS_ADJUSTMENT -y -o json" $STRIDE_CHAIN_BINARY $STRIDE_HOME_1
# $STRIDE_CHAIN_BINARY tx interchain-accounts controller send-tx connection-0 delegate_packet.json --from $MONIKER_1 --home $STRIDE_HOME_1 --chain-id $STRIDE_CHAIN_ID --gas auto --fees $BASE_FEES$STRIDE_DENOM --gas-adjustment 1.2 -y -o json | jq '.'
# sleep 10
$CHAIN_BINARY q staking validator $VALOPER_3 -o json --home $HOME_1 | jq '.'
$CHAIN_BINARY q bank balances $$ICA_ADDRESS -o json --home $HOME_1 | jq '.'

# $CHAIN_BINARY q staking validator $VALOPER_2 -o json --home $HOME_1 | jq '.'
# jq -r --arg ADDRESS "$ICA_ADDRESS" '.delegator_address = $ADDRESS' tests/v12_upgrade/msg-delegate.json > delegate-2.json
# message=$(jq -r --arg ADDRESS "$VALOPER_2" '.validator_address = $ADDRESS' delegate-2.json)
# echo "Generating packet JSON..."
# $STRIDE_CHAIN_BINARY tx interchain-accounts host generate-packet-data "$message" > delegate_packet.json
# echo "Sending tx..."
# $STRIDE_CHAIN_BINARY tx interchain-accounts controller send-tx connection-0 delegate_packet.json --from $MONIKER_1 --home $STRIDE_HOME_1 --chain-id $STRIDE_CHAIN_ID --gas auto --fees $BASE_FEES$STRIDE_DENOM --gas-adjustment 1.2 -y -o json | jq '.'
# sleep 10
# $CHAIN_BINARY q staking validator $VALOPER_2 -o json --home $HOME_1 | jq '.'
