
# trsh

A bash framework, platform, tools.

Why not modernish...
Why not bash-it...

My philosphy...

## Creating basic script with the framework

```bash
#!/usr/bin/env trsh

NAME="test"

TEST_OPTIONS=(
    run
    sample-op
)

_test_sample_op_doc=$(cat <<-END
    Sample of functionality
END
)
function test.sample_op() {
    local definitions=("user u" "branch b" "start_time s" "? isset" )
    local -A args
    getopts.getopts "$@"
    echo "Arguments $@"

    echo "options ${!args[@]}"
    echo "option user value:[${args[user]}]"
    echo "option branch value:[${args[branch]}]"
    echo "option start_time value:[${args[start_time]}]"
    echo "option isset value:[${args[isset]}]"

}

function test.run() {
:
}

cli.define_options "${TEST_OPTIONS[*]}"
cli.define_name "$NAME"
cli.run "$@"
```

