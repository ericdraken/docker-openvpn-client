#!/bin/sh

# Start Squid
echo "Starting Squid"

# Prevent stale PID (https://github.com/phusion/baseimage-docker/issues/227)
rm -rf /var/run/squid.pid

#svwaitup 10 /service/openvpn || exit 1
exec squid -sN