#!/usr/bin/env bash

set -e

service dbus start
service bluetooth start
timeout 10s bash -c 'until service bluetooth status; do sleep 1; done'
bluetoothctl list

if [[ "${INTIFACE_CLI_REDOWNLOAD_DEVICE_CONFIG}" == "true" ]]; then
  wget -qO device-config.json https://raw.githubusercontent.com/buttplugio/buttplug/master/buttplug/buttplug-device-config/buttplug-device-config.json
fi

IntifaceCLI --version

# https://github.com/intiface/intiface-cli-rs#running
if [[ "${INTIFACE_CLI_OVERRIDE_ALL_ARGS}" == "false" ]]; then
  exec IntifaceCLI \
    --servername "${INTIFACE_CLI_SERVER_NAME}" \
    --deviceconfig device-config.json \
    --stayopen \
    --wsallinterfaces \
    --wsinsecureport 12345 \
    --log "${INTIFACE_CLI_LOG_LEVEL}" \
    ${INTIFACE_CLI_WITHOUT}
else
  exec IntifaceCLI ${INTIFACE_CLI_OVERRIDE_ALL_ARGS}
fi

# TODO --stayopen wanted?
