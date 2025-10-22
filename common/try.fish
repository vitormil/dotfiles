#!/usr/bin/env fish
# -----------------------------------------------------------------------------
# Project: try - a lightweight shell script that gives each of your experiments a dedicated directory.
# Author: Vitor Oliveira
# License: MIT
#
# Copyright (c) 2025 Vitor Oliveira
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the “Software”), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
# -----------------------------------------------------------------------------

# Instead of cluttering your system with test, test2, and final-test,
# it instantly spins up a fresh workspace and drops you right in—keeping
# your ideas organized without slowing down your flow.

# Inspired by https://github.com/tobi/try

# Usage:
#   try               # list and cd into existing projects
#   try add|new       # create a new project
#   try remove|rm     # remove an existing project
#   try <query>       # fuzzy search and cd into an existing project

# Base dir: ~/src/tries

# Dependencies:
#   fzf: for fuzzy searching directories
#   fd: for finding directories
#   trashy: for safely deleting directories
#   gum: for confirmation prompt

function try
    # ADD
    if contains "$argv[1]" "add" "new"
        set current_date (date +"%Y-%m-%d")
        set project_name (read -P "📋 Project name: $current_date-")
        if test -z "$project_name"
            echo "Error: Project name cannot be empty"
            return 1
        end

        set project_name (string replace -a " " "-" $project_name)
        set project_dir "$HOME/src/tries/$current_date-$project_name"

        if test -d "$project_dir"
            echo "Warning: Directory $project_dir already exists"
            return 1
        end

        mkdir -p "$project_dir"
        if test $status -eq 0
            echo "Created project directory: $project_dir"
            cd "$project_dir"
        else
            echo "Error: Failed to create directory $project_dir"
            return 1
        end

    # REMOVE
    else if contains "$argv[1]" "remove" "rm"
        set selected_dir (fzfdir ~/src/tries --header "🗑️ Select directory to DELETE" $argv[2])

        if test -z "$selected_dir" || test $status -ne 0
            echo "Operation cancelled"
            return 0
        end

        echo "🔥 Remove directory"
        ll "$selected_dir"

        gum confirm "Are you sure you want to delete?"
        if test $status -eq 0
            trash put "$selected_dir"
            if test $status -eq 0
                echo "Successfully deleted: $selected_dir"
            else
                echo "Error: Failed to delete $selected_dir"
                return 1
            end
        else
            echo "Operation cancelled"
            return 0
        end

    # NAVIGATE
    else
        set selected_dir (fzfdir ~/src/tries --header "📁 Select project directory" $argv[1])
        if test -n "$selected_dir"
            cd "$selected_dir"
            pwd
            ll
        else
            echo "Operation cancelled"
            return 0
        end
    end
end

function fzfdir
    set search_path (test (count $argv) -eq 0; and echo .; or echo $argv[1])
    set header ""
    set query ""

    set i 2
    while test $i -le (count $argv)
        if test "$argv[$i]" = "--header"
            set i (math $i + 1)
            if test $i -le (count $argv)
                set header "$argv[$i]"
            end
        else
            if test -z "$query"
                set query "$argv[$i]"
            end
        end
        set i (math $i + 1)
    end

    set fzf_cmd "fzf" "+m"
    if test -n "$header"
        set fzf_cmd $fzf_cmd "--header" "$header"
    end
    if test -n "$query"
        set fzf_cmd $fzf_cmd "--query" "$query"
    end

    set dir (fd --type d --hidden --exclude '.*' . $search_path | $fzf_cmd)
    echo $dir
end
