#!/bin/bash

# ==========================================================
# Password Aging Policy Audit
# ==========================================================

echo "=============================================="
echo "       PASSWORD AGING POLICY AUDIT"
echo "=============================================="

LOGIN_DEFS="/etc/login.defs"

if [ ! -f "$LOGIN_DEFS" ]; then
    echo "[!] ERROR: $LOGIN_DEFS was not found."
    exit 1
fi

echo
echo "[+] Reading password aging policy from $LOGIN_DEFS"
echo

PASS_MAX=$(awk '/^[[:space:]]*PASS_MAX_DAYS/ {print $2; exit}' "$LOGIN_DEFS")
PASS_MIN=$(awk '/^[[:space:]]*PASS_MIN_DAYS/ {print $2; exit}' "$LOGIN_DEFS")
PASS_WARN=$(awk '/^[[:space:]]*PASS_WARN_AGE/ {print $2; exit}' "$LOGIN_DEFS")

echo "=============================================="
echo "SYSTEM PASSWORD POLICY"
echo "=============================================="

echo "Maximum password age : ${PASS_MAX:-NOT SET}"
echo "Minimum password age : ${PASS_MIN:-NOT SET}"
echo "Password warning age : ${PASS_WARN:-NOT SET}"

echo

# Validate maximum password age
if [ -z "$PASS_MAX" ] || [ "$PASS_MAX" -le 0 ]; then
    echo "[!] WARNING: Maximum password age is not properly configured."
else
    echo "[+] Maximum password age is configured."
fi

# Validate minimum password age
if [ -z "$PASS_MIN" ]; then
    echo "[!] WARNING: Minimum password age is not configured."
else
    echo "[+] Minimum password age is configured."
fi

# Validate warning period
if [ -z "$PASS_WARN" ] || [ "$PASS_WARN" -le 0 ]; then
    echo "[!] WARNING: Password warning age is not configured."
else
    echo "[+] Password warning period is configured."
fi

echo

# Check actual user password aging
echo "=============================================="
echo "USER PASSWORD AGING"
echo "=============================================="

while IFS=: read -r username _ uid _ _ _ shell; do

    if [ "$uid" -eq 0 ] || [ "$uid" -ge 1000 ]; then

        if id "$username" >/dev/null 2>&1; then

            echo
            echo "--- $username ---"

            chage -l "$username" 2>/dev/null |
                grep -E "Last password change|Password expires|Password inactive|Account expires"

        fi

    fi

done < /etc/passwd

echo

echo "=============================================="
echo "FINAL SECURITY ASSESSMENT"
echo "=============================================="

if [ -z "$PASS_MAX" ] || [ "$PASS_MAX" -le 0 ]; then
    echo "[!] REVIEW REQUIRED: Password aging policy needs attention."
else
    echo "[+] Password aging policy is configured."
fi
