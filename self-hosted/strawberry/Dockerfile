FROM ghcr.io/linuxserver/baseimage-kasmvnc:ubuntujammy

RUN rm -f /etc/apt/sources.list.d/nodesource.list \
    && apt-get update \
    && apt-get install -y software-properties-common gnupg curl \
    && add-apt-repository -y ppa:jonaski/strawberry \
    && apt-get update \
    && apt-get install -y \
        strawberry \
        gstreamer1.0-plugins-base \
        gstreamer1.0-plugins-good \
        gstreamer1.0-plugins-bad \
        gstreamer1.0-plugins-ugly \
        pulseaudio \
    && rm -rf /var/lib/apt/lists/*

# Autostart via script de inicio de KasmVNC
RUN mkdir -p /custom-cont-init.d && \
    printf '#!/bin/bash\nstrawberry &\n' > /custom-cont-init.d/strawberry.sh && \
    chmod +x /custom-cont-init.d/strawberry.sh
