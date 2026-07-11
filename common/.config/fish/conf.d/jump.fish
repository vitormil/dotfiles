# Jump around the filesystem using marks: symlinks stored in $MARKPATH
# pointing at directories. Port of ohmyzsh's jump plugin.
#
# jump NAME:   cd to the directory a mark points at
# mark [NAME]: create a mark for $PWD (defaults to its basename)
# unmark NAME: delete a mark
# marks:       list all marks

set -gx MARKPATH $HOME/.marks

function jump
    set -l target (readlink $MARKPATH/$argv[1] 2>/dev/null)
    if test -z "$target"
        echo "No such mark: $argv[1]"
        return 1
    end
    cd "$target" 2>/dev/null
    or begin
        echo "Destination does not exist for mark [$argv[1]]: $target"
        return 2
    end
end

function mark
    set -l name $argv[1]
    if test -z "$name" -o "$name" = "."
        set name (basename $PWD)
    end
    mkdir -p $MARKPATH
    ln -sfn "$PWD" "$MARKPATH/$name"
end

function unmark
    rm "$MARKPATH/$argv[1]"
end

function marks
    set -l names
    for link in $MARKPATH/*
        test -L $link; and set -a names (basename $link)
    end
    set -l max 0
    for name in $names
        test (string length $name) -gt $max; and set max (string length $name)
    end
    for name in $names
        set_color cyan
        printf "%*s" $max $name
        set_color normal
        printf " -> "
        set_color blue
        printf "%s" (readlink $MARKPATH/$name)
        set_color normal
        printf "\n"
    end
end

complete -c jump -f -a "(basename $MARKPATH/* 2>/dev/null)"
complete -c unmark -f -a "(basename $MARKPATH/* 2>/dev/null)"
