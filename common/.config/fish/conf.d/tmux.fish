if status is-interactive
    tmux source ~/.tmux.conf >/dev/null 2>&1
end

set -g tmux_custom_names \
    "bin/dev"   "💻 Server" \
    "bin/jobs"   "🗂 SolidQueue" \
    "dev"   "💻 Server" \
    "rails"   "🤖 Rails" \
    "r"   "🤖 Rails" \
    "claude"   "✨ Claude" \
    "deploy"   "🚀 Deploy" \
    "docker-compose"   "🐳 Docker" \
    "docker"   "🐳 Docker"

function _tmux_lookup_title
    set -l cmd $argv[1]
    set i 1
    while test $i -le (count $tmux_custom_names)
        if test "$tmux_custom_names[$i]" = "$cmd"
            set -l title $tmux_custom_names[(math $i + 1)]
            if test "$cmd" = "claude"
                set -l folder (basename (pwd))
                echo "$title [$folder]"
            else
                echo $title
            end
            return
        end
        set i (math $i + 2)
    end
    echo $cmd
end

function _tmux_manual_rename
    string match -q "1" (tmux show-window-option -v @manual_rename 2>/dev/null)
end

function _tmux_manual_rename_for_target
    set -l target $argv[1]
    string match -q "1" (tmux show-window-option -v -t $target @manual_rename 2>/dev/null)
end

function _tmux_pane_focus_rename
    set -l pane_id $argv[1]
    test -z "$pane_id"; and return
    if _tmux_manual_rename_for_target $pane_id
        return
    end
    set -l cmd (tmux display-message -p -t $pane_id '#{pane_current_command}')
    set -l path (tmux display-message -p -t $pane_id '#{pane_current_path}')
    cd $path 2>/dev/null
    if test "$cmd" = "fish"
        tmux rename-window -t $pane_id (_tmux_folder_title)
    else
        tmux rename-window -t $pane_id (_tmux_lookup_title $cmd)
    end
end

function _tmux_claude_title
    echo "✨ Claude ["(basename (pwd))"]"
end

function _tmux_folder_title
    set -l git_root (git rev-parse --show-toplevel 2>/dev/null)
    if test -z "$git_root"
        echo " "(basename (pwd))
    else if test "$git_root" = (pwd)
        echo " "(basename $git_root)
    else
        echo " "(basename $git_root)/(basename (pwd))
    end
end

function update_tmux_title --on-event fish_prompt
    if test -n "$TMUX"; and not _tmux_manual_rename
        if set -q __tmux_claude_running
            tmux rename-window (_tmux_claude_title)
            return
        end

        set cmd (ps -o comm= -p $fish_pid 2>/dev/null | string trim | string split ' ')[1]
        set cmd (string replace -r '^-' '' -- $cmd)

        if test "$cmd" = "fish"
            tmux rename-window (_tmux_folder_title)
        else
            tmux rename-window (_tmux_lookup_title $cmd)
        end
    end
end

function fish_preexec --on-event fish_preexec
    if test -n "$TMUX"; and not _tmux_manual_rename
        set cmd (string split ' ' $argv[1])[1]

        if test "$cmd" = "claude"
            set -g __tmux_claude_running 1
            tmux rename-window (_tmux_claude_title)
            return
        end

        tmux rename-window (_tmux_lookup_title $cmd)
    end
end

function fish_postexec --on-event fish_postexec
    if set -q __tmux_claude_running
        set -e __tmux_claude_running
    end
end
