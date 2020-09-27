#!/bin/sh

size=$(btrfs fi usage -b "$1" | grep size | awk '{print $3}')
allocated=$(btrfs fi usage -b "$1" | grep " allocated" | awk '{print $3}')

eightypercent=$(( 4 * size / 5 ))
twogig=$(( size - 2147483648  ))

if [ "$eightypercent" -gt "$twogig" ]; then
  cond="$eightypercent"
else
  cond="$twogig"
fi

echo "$cond" "$allocated"

if [ "$allocated" -gt "$cond" ]; then
  check1="true"
else
  check1="false"
fi

spaceallocated=$(btrfs fi usage -b "$1" | grep Data | grep Size | awk '{print $2}' | tr -c -d [0-9])
spaceused=$(btrfs fi usage -b "$1" | grep Data | grep Size | awk '{print $3}' | tr -c -d [0-9])

spacediff=$(( spaceallocated - spaceused ))

chunksize=$(( size / 10 ))

if [ "$chunksize" -lt 1073741824 ]; then
  chunk="$chunksize"
else
  chunk="1073741824"
fi

echo "$chunk" "$spacediff"

if [ "$spacediff" -gt  "$chunk" ]; then
  check2="true"
else
  check2="false"
fi

echo "$check1"
echo "$check2"
