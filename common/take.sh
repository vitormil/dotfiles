function take() {
  if [[ $1 =~ ^(https?|ftp).*\.tar\.(gz|bz2|xz)$ ]]; then
    takeAndUncompress "$1"
  elif [[ $1 =~ ^(https?|ftp).*\.git$ ]]; then
    takegit "$1"
  elif [[ $1 =~ ^https?.*$ ]]; then
    takeraw "$1"
  else
    takedir "$@"
  fi
}

function mkcd takedir() {
  mkdir -p $@ && cd ${@:$#}
}

function takegit() {
  git clone "$1"
  cd "$(basename ${1%%.git})"
}

function takeAndUncompress() {
  local data thedir
  data="$(mktemp)"
  curl -L "$1" > "$data"
  tar xf "$data"
  thedir="$(tar tf "$data" | head -n 1)"
  rm "$data"
  cd "$thedir"
}

function takeraw() {
  filename=$(basename "$1")
  wget "$1" -O "$filename"
  cat "$filename"
}
