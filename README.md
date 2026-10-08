# Lynis Custom Security Tests

Custom security auditing scripts developed as an extension to the
Lynis security auditing framework on Debian Linux.

## Overview

This project extends Lynis with additional security checks that are not
directly covered by the default audit configuration.

The project currently implements two custom security checks:

1. SUID/SGID File Security Audit
2. Password Aging Policy Audit

These checks are integrated into Lynis through the `tests_custom` file
and are also provided as standalone shell scripts.

---

## Project Structure

```text
lynis-custom-security-tests/
│
├── suid_sgid_audit.sh
├── password_aging_audit.sh
└── README.md
