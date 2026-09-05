# Virtual MetaTrader 5 (Deriv build) on Render — KasmVNC browser interface (no auth)
FROM gmag11/metatrader5_vnc:latest

# Bundled Deriv MT5 installer — auto-installed by /Metatrader/start.sh on first boot
COPY deriv5setup.exe /deriv5setup.exe
COPY start.sh /Metatrader/start.sh
RUN chmod +x /Metatrader/start.sh

# KasmVNC web interface runs on port 3000
EXPOSE 3000

# Disable KasmVNC login — open access
ENV PASSWORD=

# Use the base image's default init system
ENTRYPOINT ["/init"]
