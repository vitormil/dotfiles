#!/bin/bash
CURRENT_DATETIME=$(date)
TEMPFILE=$(mktemp)

if [ -z "$1" ]; then
  echo "$CURRENT_DATETIME\n[ ] \n\n-------------\n" > "$TEMPFILE"
else
  echo "$CURRENT_DATETIME\n[ ] $1\n\n-------------\n" > "$TEMPFILE"
fi

cat "$TODO_FILE" >> "$TEMPFILE"
mv "$TEMPFILE" "$TODO_FILE"
