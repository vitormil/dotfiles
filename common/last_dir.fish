function save_last_dir --on-event fish_exit
    pwd > ~/.last_dir
end

function restore_last_dir --on-event fish_prompt
    if test -f ~/.last_dir
        cd (cat ~/.last_dir)
    end
    functions -e restore_last_dir
end
