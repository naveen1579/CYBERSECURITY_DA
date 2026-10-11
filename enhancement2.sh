# Test        : CUST-1040
# Description : Check /tmp existence, sticky bit,
#               permissions and ownership

Register --test-no CUST-1040 --weight L --network NO \
    --category security \
    --description "Temporary directory permission audit"

if [ "${SKIPTEST}" -eq 0 ]; then
    if DirectoryExists /tmp; then
        permissions=$(stat -c '%a' /tmp)
        owner=$(stat -c '%U' /tmp)

        LogText "Result: /tmp exists"
        LogText "Result: /tmp owner is ${owner}"
        LogText "Result: /tmp permissions are ${permissions}"

        if [ -k /tmp ]; then
            LogText "Result: /tmp sticky bit is enabled"
        else
            LogText "Warning: /tmp sticky bit is missing"
        fi

        if [ "$permissions" = "1777" ] && [ "$owner" = "root" ]; then
            LogText "Result: /tmp permissions and ownership are expected"
        else
            LogText "Warning: /tmp permissions or ownership need review"
            LogText "Recommendation: review with stat /tmp; expected mode is 1777 and owner root"
        fi
    else
        LogText "Warning: /tmp directory not found"
    fi
fi
