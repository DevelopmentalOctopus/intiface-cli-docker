FROM ubuntu:22.04
# https://github.com/intiface/intiface-cli-rs/releases/latest
ARG INTIFACE_CLI_VERSION=50

RUN mkdir -p /opt/intiface
ENV PATH /opt/intiface:$PATH
WORKDIR /opt/intiface
# NOTE: some packages that are useful for debugging: bluez-tools, bluez-hcidump, btscanner, rfkill, usbutils

# https://github.com/intiface/intiface-desktop#linux-issues
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get -qy update \
 && apt-get install -qy \
    bluez \
    libcap2-bin \
    unzip \
    wget \
 && apt-get -qy clean \
 && rm -rf /var/lib/apt/lists/* \
 && wget -qO intiface-cli.zip https://github.com/intiface/intiface-cli-rs/releases/download/v${INTIFACE_CLI_VERSION}/intiface-cli-rs-linux-x64-Release.zip \
 && unzip intiface-cli.zip \
 && rm intiface-cli.zip \
 && chmod +x IntifaceCLI \
 && setcap cap_net_raw+eip IntifaceCLI \
 && wget -qO device-config.json https://raw.githubusercontent.com/buttplugio/buttplug/master/buttplug/buttplug-device-config/buttplug-device-config.json \
 && echo BLUETOOTH_ENABLED=1 | tee -a /etc/default/bluetooth

# TODO check for 404; version might have been bumped.
RUN wget -qO libssl.deb http://nz2.archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1l-1ubuntu1.6_amd64.deb \
 && dpkg -i libssl.deb \
 && rm libssl.deb

COPY entrypoint.sh .
RUN chmod 755 entrypoint.sh

ENTRYPOINT "/opt/intiface/entrypoint.sh"
EXPOSE 12345

# Off/Error/Warn/Info/Debug/Trace
ENV INTIFACE_CLI_LOG_LEVEL 'Info'
ENV INTIFACE_CLI_SERVER_NAME 'Intiface Server'
ENV INTIFACE_CLI_WITHOUT '--without-hid --without-serial --without-lovense-dongle-hid --without-lovense-dongle-serial'
ENV INTIFACE_CLI_OVERRIDE_ALL_ARGS 'false'

ENV INTIFACE_CLI_REDOWNLOAD_DEVICE_CONFIG 'true'
