#!/bin/bash

# ==========================================================
# LynisGuard - Enhancement 1
# Detailed SUID/SGID File Analysis
# ==========================================================

echo "=============================================="
echo "       SUID/SGID DETAILED SECURITY AUDIT"
echo "=============================================="

echo

# Find SUID files
SUID_FILES=$(find / -xdev -type f -perm -4000 2>/dev/null)
SUID_COUNT=$(echo "$SUID_FILES" | grep -c .)

# Find SGID files
SGID_FILES=$(find / -xdev -type f -perm -2000 2>/dev/null)
SGID_COUNT=$(echo "$SGID_FILES" | grep -c .)

echo "SUID files found: $SUID_COUNT"
echo "SGID files found: $SGID_COUNT"

echo

# SUID details
echo "=============================================="
echo "SUID FILE DETAILS"
echo "=============================================="

if [ "$SUID_COUNT" -gt 0 ]; then
    while IFS= read -r file; do
        stat -c "%A | Owner: %U | Group: %G | File: %n" "$file"
    done <<< "$SUID_FILES"
else
    echo "No SUID files found."
fi

echo

# SGID details
echo "=============================================="
echo "SGID FILE DETAILS"
echo "=============================================="

if [ "$SGID_COUNT" -gt 0 ]; then
    while IFS= read -r file; do
        stat -c "%A | Owner: %U | Group: %G | File: %n" "$file"
    done <<< "$SGID_FILES"
else
    echo "No SGID files found."
fi

echo

echo "=============================================="
echo "AUDIT COMPLETE"
echo "=============================================="
