#!/bin/bash

# Configuration variables
mt5file='/config/.wine/drive_c/Program Files/MetaTrader 5/terminal64.exe'
WINEPREFIX='/config/.wine'
WINEDEBUG='-all'
wine_executable="wine"
MT5_CMD_OPTIONS="${MT5_CMD_OPTIONS:-}"
mt5setup_url="https://download.mql5.com/cdn/web/metaquotes.software.corp/mt5/mt5setup.exe"

# Check for necessary dependencies
if ! command -v curl >/dev/null 2>&1; then
    echo "curl is not installed."
    exit 1
fi
if ! command -v "$wine_executable" >/dev/null 2>&1; then
    echo "wine is not installed."
    exit 1
fi

# Set Windows 10 mode in Wine (once, harmless if already set)
$wine_executable reg add "HKEY_CURRENT_USER\\Software\\Wine" /v Version /t REG_SZ /d "win10" /f 2>/dev/null

# Install MetaTrader 5 if not present
if [ -e "$mt5file" ]; then
    echo "MT5 is already installed."
else
    echo "Downloading MT5 installer..."
    curl -o /tmp/mt5setup.exe "$mt5setup_url"
    echo "Installing MT5..."
    $wine_executable /tmp/mt5setup.exe "/auto" &
    wait
    rm -f /tmp/mt5setup.exe
fi

# Recheck — search if the installer used a different folder
if [ ! -e "$mt5file" ]; then
    mt5file="$(find "/config/.wine/drive_c/Program Files" -maxdepth 4 -name terminal64.exe 2>/dev/null | head -n1)"
fi

if [ -e "$mt5file" ]; then
    echo "Running MT5: $mt5file"
    exec $wine_executable "$mt5file" $MT5_CMD_OPTIONS
else
    echo "MT5 is not installed. Cannot run."
    sleep infinity
fi
