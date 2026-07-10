# Not in use, see: default_dir.fish

# Save the current directory to ~/.lastdir on directory change
function __lastdir_save --on-variable PWD
    echo $PWD > ~/.lastdir
end

# Restore the last directory on session start
if test -f ~/.lastdir
    set -l last_dir (cat ~/.lastdir)
    if test -d $last_dir
        cd $last_dir
    end
end
