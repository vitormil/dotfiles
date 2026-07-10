function rm
    for arg in $argv
        switch $arg
            case '/' '~' '~/' 'block-rm-test'
                echo "🚫 Refusing to remove critical path: $arg"
                return 1
        end
    end
    if test (uname) = Darwin
        command trash $argv
    else
        command trash put $argv
    end
end
