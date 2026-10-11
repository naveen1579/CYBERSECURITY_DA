
# Lynis Custom Test Enhancements: /tmp Security Audit

## Overview

This project enhances a reference Lynis custom test that checks
whether the `/tmp` directory exists on a Linux system.

Two enhancements extend the original test to provide additional
security checks and diagnostic information.

## Objectives

- Understand Lynis custom-test development.
- Verify the existence of `/tmp`.
- Check whether the sticky bit is enabled.
- Inspect directory permissions and ownership.
- Report unexpected configurations with recommendations.

## Project Structure

```text
lynis-enhancements/
├── reference.sh
├── enhancement1.sh
├── enhancement2.sh
└── README.md
```

## Reference Test

The original reference test checks whether `/tmp` exists.

- Test ID: CUST-0020
- Result: Reports whether the temporary directory exists.
- Limitation: Does not inspect permissions, ownership, or the sticky bit.

## Enhancement 1: Sticky-Bit Verification

**File:** `enhancement1.sh`

**Test ID:** CUST-1030

This enhancement checks whether `/tmp` exists and verifies
that its sticky bit is enabled.

### Features

- Checks directory existence.
- Verifies the sticky bit using the shell's `-k` test.
- Reports a result or warning.

## Enhancement 2: Permission and Ownership Audit

**File:** `enhancement2.sh`

**Test ID:** CUST-1040

This enhancement extends the first version by inspecting
the directory's permission mode and owner.

### Features

- Checks directory existence.
- Verifies the sticky bit.
- Retrieves the permission mode using `stat`.
- Retrieves the owner using `stat`.
- Compares the observed configuration with mode `1777`
  and owner `root`.
- Provides a recommendation if the configuration needs review.

## Requirements

- Linux system
- Lynis installed
- Shell utilities including `stat`
- Sufficient privileges to run a Lynis audit

## Execution

These files contain Lynis custom-test snippets. They are not
standalone shell scripts.

1. Back up your existing Lynis custom-test configuration.
2. Add the contents of one enhanced script to the custom-test
   file used by your Lynis installation.
3. Ensure the test ID is unique and the test is loaded by Lynis.
4. Run the audit:

   ```bash
   sudo lynis audit system
   ```

5. Inspect the Lynis log for the messages produced by the test.
6. Repeat with the other enhancement, avoiding duplicate test IDs.

On Debian installations, the custom-test file may be located at:

`/usr/share/lynis/include/tests_custom`

Do not overwrite existing custom tests without backing them up.

## Expected Configuration

The expected `/tmp` configuration checked by Enhancement 2 is:

- Owner: `root`
- Permission mode: `1777`
- Sticky bit: enabled

These checks provide diagnostic information and do not
automatically remediate the directory.

## Learning Outcomes

- Understanding Lynis custom tests.
- Using conditional statements for security checks.
- Understanding Linux directory permissions and ownership.
- Learning the purpose of the sticky bit.
- Extending an existing security check incrementally.
- Running custom checks through Lynis and inspecting audit logs.

## Limitations

These scripts perform a focused check of `/tmp`. They do not
constitute a complete Linux security audit. An unexpected
configuration should be reviewed before making changes.

## Author

Naveen

## Acknowledgements

Thanks to the Lynis project and its maintainers for the
open-source security auditing tool and reference template
used in this project.
