
# trshell

## TODO

[ ] Change pushd and popd to detect if needed.
[ ] Add imports to library to only import the needed parts
    [ ] Improve the package to only import the needed parts of library
        a imports should be declared in a special function.

## Creating basic script with the framework

```bash
_TEST_{OPTION}_DOC=$(cat <<-END
    {DOCUMENTATION FOR FUNCTIONALITY}
END
) 
function test.{OPTION}() {
    ...
}
```

