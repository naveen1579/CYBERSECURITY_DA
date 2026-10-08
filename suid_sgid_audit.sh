#!/bin/bash

# ==========================================================
# SUID/SGID File Security Audit
# ==========================================================

echo "=============================================="
echo "       SUID/SGID SECURITY AUDIT"
echo "=============================================="

echo

# Find SUID files
echo "[+] Scanning for SUID files..."
SUID_FILES=$(find / -xdev -type f -perm -4000 2>/dev/null)

SUID_COUNT=$(echo "$SUID_FILES" | grep -c .)

echo "    SUID files found: $SUID_COUNT"
echo

# Find SGID files
echo "[+] Scanning for SGID files..."
SGID_FILES=$(find / -xdev -type f -perm -2000 2>/dev/null)

SGID_COUNT=$(echo "$SGID_FILES" | grep -c .)

echo "    SGID files found: $SGID_COUNT"
echo

# Display SUID files
echo "=============================================="
echo "SUID FILES"
echo "=============================================="

if [ "$SUID_COUNT" -gt 0 ]; then
    while IFS= read -r file; do
        stat -c "%A | %U:%G | %n" "$file"
    done <<< "$SUID_FILES"
else
    echo "No SUID files found."
fi

echo

# Display SGID files
echo "=============================================="
echo "SGID FILES"
echo "=============================================="

if [ "$SGID_COUNT" -gt 0 ]; then
    while IFS= read -r file; do
        stat -c "%A | %U:%G | %n" "$file"
    done <<< "$SGID_FILES"
else
    echo "No SGID files found."
fi

echo

# Check for world-writable SUID/SGID files
echo "=============================================="
echo "WORLD-WRITABLE SUID/SGID FILES"
echo "=============================================="

DANGEROUS=$(find / -xdev -type f \
    \( -perm -4000 -o -perm -2000 \) \
    -perm -0002 2>/dev/null)

DANGEROUS_COUNT=$(echo "$DANGEROUS" | grep -c .)

echo "World-writable SUID/SGID files: $DANGEROUS_COUNT"

if [ "$DANGEROUS_COUNT" -gt 0 ]; then
    echo
    echo "[!] WARNING: Potentially dangerous files detected."
    echo "$DANGEROUS"
else
    echo "[+] No world-writable SUID/SGID files detected."
fi

echo

# Check ownership
echo "=============================================="
echo "NON-ROOT-OWNED SUID/SGID FILES"
echo "=============================================="

NON_ROOT=$(find / -xdev -type f \
    \( -perm -4000 -o -perm -2000 \) \
    ! -user root 2>/dev/null)

NON_ROOT_COUNT=$(echo "$NON_ROOT" | grep -c .)

echo "Non-root-owned SUID/SGID files: $NON_ROOT_COUNT"

if [ "$NON_ROOT_COUNT" -gt 0 ]; then
    echo
    echo "[!] WARNING: Non-root-owned SUID/SGID files detected."
    echo "$NON_ROOT"
else
    echo "[+] All detected SUID/SGID files are root-owned."
fi

echo

# Final result
echo "=============================================="
echo "FINAL SECURITY ASSESSMENT"
echo "=============================================="

if [ "$DANGEROUS_COUNT" -gt 0 ] || [ "$NON_ROOT_COUNT" -gt 0 ]; then
    echo "[!] REVIEW REQUIRED"
else
    echo "[+] SUID/SGID permissions appear acceptable."
fi
