Register --test-no CUST-0020 --weight L --network NO --category security --description "Dealing with files and directories"

if [ ${SKIPTEST} -eq 0 ]; then

    # With -d we can test for directories, -f is for files, -L for symlinks.
    if DirectoryExists /tmp; then
        LogText "Result: we have a temporary directory"
    else
        LogText "Result: no temporary directory found"
    fi
fi
