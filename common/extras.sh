alias quote="ruby $HOME/vitor/quotes/quote.rb --color"
alias quote-copy="ruby $HOME/vitor/quotes/quote.rb --no-color | tr -d '\n' | pbcopy && pbpaste"
alias qc="quote-copy"

alias spy="$HOME/dev/webspy-cli && ./bin/rails spy:recent"
alias "spy:all"="$HOME/dev/webspy-cli && ./bin/rails spy:all"
