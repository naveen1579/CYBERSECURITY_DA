#!/bin/bash

# ==========================================================
# LynisGuard - Enhancement 2
# SUID/SGID Risk Analysis
# ==========================================================

echo "=============================================="
echo "       SUID/SGID SECURITY RISK AUDIT"
echo "=============================================="

echo

# Count SUID and SGID files
SUID_COUNT=$(find / -xdev -type f -perm -4000 2>/dev/null | wc -l)
SGID_COUNT=$(find / -xdev -type f -perm -2000 2>/dev/null | wc -l)

echo "SUID files found: $SUID_COUNT"
echo "SGID files found: $SGID_COUNT"

echo

# ----------------------------------------------------------
# Check world-writable SUID/SGID files
# ----------------------------------------------------------

echo "=============================================="
echo "WORLD-WRITABLE SUID/SGID FILES"
echo "=============================================="

DANGEROUS=$(find / -xdev -type f \
    \( -perm -4000 -o -perm -2000 \) \
    -perm -0002 2>/dev/null)

if [ -n "$DANGEROUS" ]; then
    DANGEROUS_COUNT=$(echo "$DANGEROUS" | wc -l)

    echo "World-writable SUID/SGID files: $DANGEROUS_COUNT"
    echo
    echo "[!] WARNING: Potentially dangerous files detected."
    echo "$DANGEROUS"
else
    DANGEROUS_COUNT=0
    echo "World-writable SUID/SGID files: 0"
    echo "[+] No world-writable SUID/SGID files detected."
fi

echo

# ----------------------------------------------------------
# Check non-root-owned SUID/SGID files
# ----------------------------------------------------------

echo "=============================================="
echo "NON-ROOT-OWNED SUID/SGID FILES"
echo "=============================================="

NON_ROOT=$(find / -xdev -type f \
    \( -perm -4000 -o -perm -2000 \) \
    ! -user root 2>/dev/null)

if [ -n "$NON_ROOT" ]; then
    NON_ROOT_COUNT=$(echo "$NON_ROOT" | wc -l)

    echo "Non-root-owned SUID/SGID files: $NON_ROOT_COUNT"
    echo
    echo "[!] WARNING: Non-root-owned files detected."
    echo "$NON_ROOT"
else
    NON_ROOT_COUNT=0
    echo "Non-root-owned SUID/SGID files: 0"
    echo "[+] All detected SUID/SGID files are root-owned."
fi

echo

# ----------------------------------------------------------
# Final risk assessment
# ----------------------------------------------------------

echo "=============================================="
echo "FINAL SECURITY ASSESSMENT"
echo "=============================================="

if [ "$DANGEROUS_COUNT" -gt 0 ] || [ "$NON_ROOT_COUNT" -gt 0 ]; then
    echo "[!] REVIEW REQUIRED"
else
    echo "[+] SUID/SGID permissions appear acceptable."
fi

echo "=============================================="
