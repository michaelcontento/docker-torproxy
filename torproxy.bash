#!/bin/bash
set -e

log() {
    echo "TORPROXY: $@"
}

tor --SocksPort 9051 &
torPID=$!
log "tor process started (PID: $torPID)"

# https://gitweb.torproject.org/torbrowser.git/blob_plain/1ffcd9dafb9dd76c3a29dd686e05a71a95599fb5:/build-scripts/config/polipo.conf
polipo \
    allowedPorts=1-65535 \
    cacheIsShared=false \
    censoredHeaders=from,accept-language,x-pad,link \
    censorReferer=maybe \
    disableConfiguration=true \
    disableLocalInterface=true \
    disableVia=true \
    diskCacheRoot="" \
    dnsUseGethostbyname=true \
    localDocumentRoot="" \
    maxConnectionAge=5m \
    maxConnectionRequests=120 \
    proxyAddress=0.0.0.0 \
    proxyName="localhost" \
    proxyPort=9050 \
    serverMaxSlots=8 \
    serverSlots=2 \
    socksParentProxy=127.0.0.1:9051 \
    socksProxyType=socks5 \
    tunnelAllowedPorts=1-65535 &
polipoPID=$!
log "polipo process started (PID: $polipoPID)"

trap 'log "requested shutdown"; kill -9 $torPID $polipoPID 2>/dev/null; exit' SIGINT SIGTERM

log "all processes spawned! begin monitoring phase"
while sleep 1; do
    if ! kill -0 $torPID 2>/dev/null; then
        log "panic shutdown: tor process died!"
        kill $polipoPID
        exit 1
    fi
    if ! kill -0 $polipoPID 2>/dev/null; then
        log "panic shutdown: polipo process died!"
        kill $torPID
        exit 1
    fi
done
