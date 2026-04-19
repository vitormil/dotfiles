if status is-interactive
    tmux source ~/.tmux.conf >/dev/null 2>&1
end

set -g tmux_custom_names \
    "bin/dev"   "💻 Server" \
    "rails"   "🤖 Rails" \
    "r"   "🤖 Rails" \
    "docker-compose"   "🐳 Docker"

function _tmux_lookup_title
    set -l cmd $argv[1]
    set i 1
    while test $i -le (count $tmux_custom_names)
        if test "$tmux_custom_names[$i]" = "$cmd"
            echo $tmux_custom_names[(math $i + 1)]
            return
        end
        set i (math $i + 2)
    end
    echo $cmd
end

function _tmux_manual_rename
    string match -q "1" (tmux show-window-option -v @manual_rename 2>/dev/null)
end

function update_tmux_title --on-event fish_prompt
    if test -n "$TMUX"; and not _tmux_manual_rename
        set cmd (ps -o comm= -p $fish_pid 2>/dev/null | string trim | string split ' ')[1]

        if test "$cmd" = "fish"
            tmux rename-window (string replace -r "^$HOME" "~" (pwd))
        else
            tmux rename-window (_tmux_lookup_title $cmd)
        end
    end
end

function fish_preexec --on-event fish_preexec
    if test -n "$TMUX"; and not _tmux_manual_rename
        set cmd (string split ' ' $argv[1])[1]
        tmux rename-window (_tmux_lookup_title $cmd)
    end
end
