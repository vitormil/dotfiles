export LANG=en_US.UTF-8
export GPG_TTY=$(tty)

export ZSH_CACHE_DIR="$HOME/.cache/zsh"
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#616970"

export RAILS_ENV="development"

export BAT_THEME="ansi"

export PGUSER="postgres"
export PGPASSWORD="postgres"

export TODO_FILE="$HOME/vitor/TODO.txt"

export MVN_HOME=/opt/homebrew/opt/maven/libexec
export M2_HOME=$MVN_HOME
export M2=$M2_HOME/bin

export MAVEN_OPTS="-Djava.net.preferIPv4Stack=true --add-exports=java.base/sun.net.spi=ALL-UNNAMED --add-opens=java.base/sun.net.spi=ALL-UNNAMED --add-opens=java.base/java.util.regex=ALL-UNNAMED --add-opens=java.base/java.net=ALL-UNNAMED --add-opens=java.base/java.util=ALL-UNNAMED --add-opens=java.base/java.lang=ALL-UNNAMED --add-opens=java.base/java.lang.reflect=ALL-UNNAMED --add-opens=java.base/java.io=ALL-UNNAMED"
export JAVA_OPTS="-Djava.net.preferIPv4Stack=true --add-exports=java.base/sun.net.spi=ALL-UNNAMED --add-opens=java.base/sun.net.spi=ALL-UNNAMED --add-opens=java.base/java.util.regex=ALL-UNNAMED --add-opens=java.base/java.net=ALL-UNNAMED --add-opens=java.base/java.util=ALL-UNNAMED --add-opens=java.base/java.lang=ALL-UNNAMED --add-opens=java.base/java.lang.reflect=ALL-UNNAMED --add-opens=java.base/java.io=ALL-UNNAMED"

export BAT_THEME="Catppuccin Mocha"

export PATH=$M2:$PATH
export PATH=$PATH:$HOME/.rd/bin
export PATH=$PATH:/opt/homebrew/opt/libpq/bin
