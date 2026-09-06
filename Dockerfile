# Virtual MetaTrader 5 (Deriv build) on Render — KasmVNC browser interface (no auth)
FROM gmag11/metatrader5_vnc:latest

# Bundled Deriv MT5 installer — auto-installed by /Metatrader/start.sh on first boot
COPY deriv5setup.exe /deriv5setup.exe
COPY start.sh /Metatrader/start.sh
RUN chmod +x /Metatrader/start.sh

# Patch KasmVNC client to prevent crash on WebSocket disconnect (Render free-tier spin-down)
RUN bundle=$(find / -name 'main.bundle.js' -path '*/vnc/*' 2>/dev/null | head -n1) \
    && echo "Patching KasmVNC bundle: $bundle" \
    && sed -i 's|(Date.now() - UI.rfb.lastActiveAt) / 1000;|UI.rfb ? (Date.now() - UI.rfb.lastActiveAt) / 1000 : 0;|' "$bundle"

# Disable services that are not needed (audio/Docker-in-Docker) to save memory on Render free tier (512MB)
RUN echo '#!/bin/sh' > /etc/s6-overlay/s6-rc.d/svc-pulseaudio/run \
    && echo 'exec sleep infinity' >> /etc/s6-overlay/s6-rc.d/svc-pulseaudio/run \
    && chmod +x /etc/s6-overlay/s6-rc.d/svc-pulseaudio/run \
    && echo '#!/bin/sh' > /etc/s6-overlay/s6-rc.d/svc-docker/run \
    && echo 'exec sleep infinity' >> /etc/s6-overlay/s6-rc.d/svc-docker/run \
    && chmod +x /etc/s6-overlay/s6-rc.d/svc-docker/run

EXPOSE 3000
ENV PASSWORD=
ENTRYPOINT ["/init"]
