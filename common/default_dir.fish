function save_default_dir
    pwd > ~/.default_dir
end

function sdd
    save_default_dir
end

function restore_default_dir --on-event fish_prompt
    if test -f ~/.default_dir
        cd (cat ~/.default_dir)
    end
    functions -e restore_default_dir
end
