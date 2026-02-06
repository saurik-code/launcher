#!/bin/bash
# AutoCAD 2026 Launcher - Fixed Version

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="$SCRIPT_DIR/password.conf"

# Load password
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
fi

# Fungsi cek server benar-benar ready (proses + port + koneksi)
is_server_healthy() {
    # Cek proses lmgrd (hanya 1 yang boleh jalan)
    local lmgrd_count=$(pgrep -x "lmgrd" 2>/dev/null | wc -l)
    if [ "$lmgrd_count" -ne 1 ]; then
        return 1
    fi
    
    # Cek proses adskflex
    if ! pgrep -x "adskflex" > /dev/null 2>&1; then
        return 1
    fi
    
    # Cek port 27080 benar-benar listening
    if ! netstat -an 2>/dev/null | grep -q "127.0.0.1.27080"; then
        return 1
    fi
    
    # Cek bisa konek ke port
    if ! (echo > /dev/tcp/127.0.0.1/27080) 2>/dev/null; then
        return 1
    fi
    
    return 0
}

# Fungsi kill semua server (bersihkan duplikat)
kill_all_servers() {
    # Kill semua instance lmgrd dan adskflex
    sudo pkill -9 -x "lmgrd" 2>/dev/null
    sudo pkill -9 -x "adskflex" 2>/dev/null
    sudo pkill -9 -f "lmgrd" 2>/dev/null
    sudo pkill -9 -f "adskflex" 2>/dev/null
    
    # Clear port
    for pid in $(sudo lsof -t -i :27080 2>/dev/null); do
        sudo kill -9 $pid 2>/dev/null
    done
    
    sleep 2
}

# Cek status server
lmgrd_count=$(pgrep -x "lmgrd" 2>/dev/null | wc -l)

if [ "$lmgrd_count" -gt 1 ]; then
    # Ada duplikat! Bersihkan dulu
    osascript -e 'display notification "Membersihkan server duplikat..." with title "AutoCAD Launcher"'
    kill_all_servers
fi

# Cek apakah server sudah berjalan normal
if is_server_healthy; then
    osascript -e 'display notification "License server aktif" with title "AutoCAD Launcher"'
else
    osascript -e 'display notification "Menjalankan license server..." with title "AutoCAD Launcher"'
    
    # Kill yang ada (jika stuck)
    kill_all_servers
    
    # Start fresh
    cd /usr/local/flexnetserver
    echo "$PASSWORD" | sudo -S ./lmgrd -c ./license.dat > /dev/null 2>&1 &
    
    # Tunggu dengan timeout
    for i in {1..15}; do
        sleep 1
        if is_server_healthy; then
            break
        fi
    done
    
    # Cek hasil
    if ! is_server_healthy; then
        osascript -e 'display alert "Error Server" message "License server tidak dapat dijalankan dengan benar. Coba gunakan Kill AutoCAD kemudian coba lagi." buttons {"OK"}'
        exit 1
    fi
    
    osascript -e 'display notification "License server berjalan" with title "AutoCAD Launcher"'
fi

# Set env dan buka AutoCAD
launchctl setenv LM_LICENSE_FILE "27080@127.0.0.1"
launchctl setenv ADSKFLEX_LICENSE_FILE "27080@127.0.0.1"

osascript -e 'display notification "Membuka AutoCAD 2026..." with title "AutoCAD Launcher"'
open "/Applications/Autodesk/AutoCAD 2026/AutoCAD 2026.app"
