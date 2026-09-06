#!/bin/bash

# Configuration variables
mt5file='/config/.wine/drive_c/Program Files/MetaTrader 5/terminal64.exe'
deriv_marker='/config/.deriv_mt5_installed'
WINEPREFIX='/config/.wine'
WINEDEBUG='-all'
wine_executable="wine"
MT5_CMD_OPTIONS="${MT5_CMD_OPTIONS:-}"

# Check for necessary dependencies
if ! command -v curl >/dev/null 2>&1; then
    echo "curl is not installed."
    exit 1
fi
if ! command -v "$wine_executable" >/dev/null 2>&1; then
    echo "wine is not installed."
    exit 1
fi

# Install Deriv MetaTrader 5 once
if [ -e "$deriv_marker" ]; then
    echo "[1/3] Deriv MetaTrader 5 is already installed."
else
    echo "[1/3] Installing Deriv MetaTrader 5..."

    # Set Windows 10 mode in Wine and install the bundled Deriv MT5 setup
    $wine_executable reg add "HKEY_CURRENT_USER\\Software\\Wine" /v Version /t REG_SZ /d "win10" /f
    echo "[2/3] Running Deriv MT5 installer..."
    $wine_executable "/deriv5setup.exe" "/auto" &
    wait
    touch "$deriv_marker"
fi

# Recheck if MetaTrader 5 is installed (search if the Deriv installer used a custom folder)
if [ ! -e "$mt5file" ]; then
    mt5file="$(find "/config/.wine/drive_c/Program Files" -maxdepth 4 -name terminal64.exe 2>/dev/null | head -n1)"
fi
if [ -e "$mt5file" ]; then
    echo "[3/3] Running MT5: $mt5file"
    exec $wine_executable "$mt5file" $MT5_CMD_OPTIONS
else
    echo "[3/3] MT5 is not installed. Cannot run."
    sleep infinity
fi
