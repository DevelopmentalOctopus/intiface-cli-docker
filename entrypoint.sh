#!/usr/bin/env bash

set -e

service dbus start
service bluetooth start
timeout 10s bash -c 'until service bluetooth status; do sleep 1; done'
bluetoothctl list

if [[ "${INTIFACE_ENGINE_REDOWNLOAD_DEVICE_CONFIG}" == "true" ]]; then
  wget -qO device-config.json https://raw.githubusercontent.com/buttplugio/buttplug/master/buttplug/buttplug-device-config/buttplug-device-config.json
fi

intiface-engine --version

# https://github.com/intiface/intiface-engine#running Though documentation currently disagrees with itself and intiface-engine --help.
if [[ "${INTIFACE_ENGINE_OVERRIDE_ALL_ARGS}" == "false" ]]; then
  exec intiface-engine \
    --server-name "${INTIFACE_ENGINE_SERVER_NAME}" \
    --device-config-file device-config.json \
    --websocket-use-all-interfaces \
    --websocket-port 12345 \
    ${INTIFACE_ENGINE_USE}
#    --log "${INTIFACE_ENGINE_LOG_LEVEL}" \ # TODO currently errors.
else
  exec intiface-engine ${INTIFACE_ENGINE_OVERRIDE_ALL_ARGS}
fi
