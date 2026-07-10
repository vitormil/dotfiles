function take
    set -l target $argv[1]

    # tarballs: .tar.gz/.bz2/.xz and short forms .tgz/.tbz2/.txz
    # allow query strings/fragments after the filename
    if string match -qr '^(https?|ftp)://.+\.(?:tar(?:\.(?:gz|bz2|xz))?|t(?:gz|bz2|xz|zst))(?:[?#].*)?$' -- $target
        takeAndUncompress $target

    # git URLs ending with .git
    else if string match -qr '^(https?|ftp|git)(://|@).*\.git(?:[?#].*)?$' -- $target
        takegit $target

    # any http/https URL (catch-all)
    else if string match -qr '^https?://.+' -- $target
        takeraw $target

    # otherwise, treat as directory
    else
        takedir $argv
    end
end

function mkcd
    mkdir -p $argv
    cd $argv[-1]
end

function takedir
    mkcd $argv
end

function takegit
    git clone $argv[1]
    set repo (basename (string replace -r '\.git$' '' $argv[1]))
    cd $repo
end

function takeAndUncompress
    set data (mktemp)
    curl -L $argv[1] > $data
    tar xf $data
    set thedir (tar tf $data | head -n 1)
    rm $data
    cd $thedir
end

function takeraw
    set filename (basename $argv[1])
    wget $argv[1] -O $filename
    cat $filename
end
