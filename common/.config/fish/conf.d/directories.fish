# Maintain a directory stack on PWD change
function __dirs_update --on-variable PWD
    if not set -q __dir_stack
        set -g __dir_stack
    end
    if test (count $__dir_stack) -eq 0; or test "$__dir_stack[1]" != "$PWD"
        set -g __dir_stack $PWD $__dir_stack
        if test (count $__dir_stack) -gt 10
            set -g __dir_stack $__dir_stack[1..10]
        end
    end
end

# List the directory stack with indices (like ZSH's `d`)
function d
    if test (count $__dir_stack) -eq 0
        echo "Directory stack is empty"
        return
    end
    set -l i 0
    for dir in $__dir_stack
        echo "$i  $dir"
        set i (math $i + 1)
    end
end

# Jump to a numbered directory in the stack
function __dir_jump
    set -l idx (math $argv[1] + 1)
    if set -q __dir_stack[$idx]
        cd $__dir_stack[$idx]
    else
        echo "No directory at index $argv[1]"
    end
end

function 1; __dir_jump 1; end
function 2; __dir_jump 2; end
function 3; __dir_jump 3; end
function 4; __dir_jump 4; end
function 5; __dir_jump 5; end
function 6; __dir_jump 6; end
function 7; __dir_jump 7; end
function 8; __dir_jump 8; end
function 9; __dir_jump 9; end
