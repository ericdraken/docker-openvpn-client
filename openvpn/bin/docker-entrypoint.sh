#!/bin/bash
set -e

if [ "${OPENVPN_CONFIG}" = "RANDOM" ]; then
  # Choose a random server
  VPN_PROVIDER="$(echo $OPENVPN_PROVIDER | tr '[A-Z]' '[a-z]')"
  PROVIDER_PATH="/etc/openvpn/conf/$VPN_PROVIDER"
  RANDOM_OVPN="$(find $PROVIDER_PATH -type f -iname "*USA*.ovpn" | shuf -n 1)"

  # Get the country name for the VPN
  OPENVPN_CONFIG="$(basename $RANDOM_OVPN .ovpn)"
  echo "Random VPN Server: $OPENVPN_CONFIG"
fi

exec "$@"