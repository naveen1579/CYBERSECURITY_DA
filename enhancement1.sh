# Test        : CUST-1030
# Description : Check /tmp existence and sticky bit

Register --test-no CUST-1030 --weight L --network NO \
    --category security \
    --description "Temporary directory security check"

if [ "${SKIPTEST}" -eq 0 ]; then
    if DirectoryExists /tmp; then
        LogText "Result: we have a temporary directory"

        if [ -k /tmp ]; then
            LogText "Result: /tmp sticky bit is enabled"
        else
            LogText "Warning: /tmp sticky bit is missing"
        fi
    else
        LogText "Warning: /tmp directory not found"
    fi
fi
