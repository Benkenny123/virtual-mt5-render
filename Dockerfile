# Virtual MetaTrader 5 on Render — KasmVNC browser interface
FROM gmag11/metatrader5_vnc:latest

# KasmVNC web interface runs on port 3000
EXPOSE 3000

# VNC password for browser access
ENV PASSWORD=mt5secure

# Use the base image's default init system
ENTRYPOINT ["/init"]
