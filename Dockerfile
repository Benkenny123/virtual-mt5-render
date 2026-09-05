# Virtual MetaTrader 5 on Render — Wine + noVNC browser interface
FROM fortesenselabs/metatrader:latest

# Render routes traffic to $PORT (defaults to 8000 for this image)
ENV VNC_PASSWORD=${VNC_PASSWORD:-mt5secure}

EXPOSE 8000

# Keep container alive and MT5 running
CMD ["sh", "-c", "echo 'MT5 Virtual Terminal running on port 8000' && /entrypoint.sh"]
