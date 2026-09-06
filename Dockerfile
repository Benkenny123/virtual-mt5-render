# Virtual MetaTrader 5 on Render — KasmVNC browser interface (no auth)
FROM gmag11/metatrader5_vnc:latest

# Lean startup script: only install + launch MT5, no Python bridge/mono/mt5linux
COPY start.sh /Metatrader/start.sh
RUN chmod +x /Metatrader/start.sh

# Patch KasmVNC client to prevent crash on WebSocket disconnect (Render free-tier spin-down)
RUN sed -i 's|(Date.now() - UI.rfb.lastActiveAt) / 1000;|UI.rfb ? (Date.now() - UI.rfb.lastActiveAt) / 1000 : 0;|' \
      /usr/local/share/kasmvnc/www/dist/main.bundle.js

EXPOSE 3000
ENV PASSWORD=
ENTRYPOINT ["/init"]
