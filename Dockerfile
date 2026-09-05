# Virtual MetaTrader 5 (Deriv build) on Render — KasmVNC browser interface (no auth)
FROM gmag11/metatrader5_vnc:latest

# Bundled Deriv MT5 installer — auto-installed by /Metatrader/start.sh on first boot
COPY deriv5setup.exe /deriv5setup.exe
COPY start.sh /Metatrader/start.sh
RUN chmod +x /Metatrader/start.sh

# Patch KasmVNC client to prevent crash on WebSocket disconnect (Render free-tier spin-down)
# Fix: guard UI.rfb before reading .lastActiveAt (KasmVNC known bug on server-initiated disconnect)
RUN bundle=$(find / -name 'main.bundle.js' -path '*/vnc/*' 2>/dev/null | head -n1) \
    && echo "Patching KasmVNC bundle: $bundle" \
    && sed -i 's|(Date.now() - UI.rfb.lastActiveAt) / 1000;|UI.rfb ? (Date.now() - UI.rfb.lastActiveAt) / 1000 : 0;|' "$bundle"

EXPOSE 3000
ENV PASSWORD=
ENTRYPOINT ["/init"]
