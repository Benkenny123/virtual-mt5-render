# Virtual MetaTrader 5 on Render — KasmVNC browser interface (no auth)
FROM gmag11/metatrader5_vnc:latest

# KasmVNC web interface runs on port 3000
EXPOSE 3000

# Disable KasmVNC login — open access
ENV PASSWORD=

# Use the base image's default init system
ENTRYPOINT ["/init"]
