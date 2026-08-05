#!/bin/bash

# Egyszerű Linux rendszerállapot-ellenőrző script

DISK_WARNING=80

echo "========================================"
echo "       LINUX SYSTEM CHECK"
echo "========================================"
echo

# Operációs rendszer
if [ -f /etc/os-release ]; then
    source /etc/os-release
    OS_NAME="$PRETTY_NAME"
else
    OS_NAME="Ismeretlen Linux rendszer"
fi

# Alapvető rendszerinformációk
echo "Operációs rendszer : $OS_NAME"
echo "Gépnév              : $(hostname)"
echo "Felhasználó         : $(whoami)"
echo "Dátum               : $(date)"
echo "Kernel              : $(uname -r)"
echo "Rendszer futási idő : $(uptime -p)"
echo

echo "----------------------------------------"
echo "MEMÓRIAHASZNÁLAT"
echo "----------------------------------------"

free -h
echo

echo "----------------------------------------"
echo "LEMEZHASZNÁLAT"
echo "----------------------------------------"

df -h /
echo

# A gyökérpartíció lemezhasználatának lekérdezése
DISK_USAGE=$(df / | awk 'NR==2 {print $5}' | tr -d '%')

if [ "$DISK_USAGE" -ge "$DISK_WARNING" ]; then
    echo "FIGYELMEZTETÉS: A lemezhasználat ${DISK_USAGE}%!"
else
    echo "A lemezhasználat megfelelő: ${DISK_USAGE}%."
fi

echo

echo "----------------------------------------"
echo "HÁLÓZATI INFORMÁCIÓK"
echo "----------------------------------------"

IP_ADDRESS=$(hostname -I 2>/dev/null | awk '{print $1}')

if [ -n "$IP_ADDRESS" ]; then
    echo "Elsődleges IP-cím: $IP_ADDRESS"
else
    echo "Az IP-cím nem állapítható meg."
fi

echo

echo "----------------------------------------"
echo "SZOLGÁLTATÁSOK ÁLLAPOTA"
echo "----------------------------------------"

check_service() {
    SERVICE_NAME="$1"

    if ! systemctl list-unit-files "${SERVICE_NAME}.service" \
        --no-legend 2>/dev/null | grep -q "^${SERVICE_NAME}.service"; then
        echo "$SERVICE_NAME: nincs telepítve"
    elif systemctl is-active --quiet "$SERVICE_NAME"; then
        echo "$SERVICE_NAME: fut"
    else
        echo "$SERVICE_NAME: nem fut"
    fi
}

check_service "sshd"
check_service "firewalld"

echo
echo "========================================"
echo "Az ellenőrzés befejeződött."
echo "========================================"
