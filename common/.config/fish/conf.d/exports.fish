export GPG_TTY=$(tty)

export RAILS_ENV="development"
export BAT_THEME="ansi"

export PGUSER="postgres"
export PGPASSWORD="docker"

export M2_HOME=(mvn -version | awk -F': ' '/Maven home/{print $2}')

export TODO_FILE="$HOME/vitor/TODO.txt"

export BAT_THEME="Catppuccin Mocha" # bat cache --build
