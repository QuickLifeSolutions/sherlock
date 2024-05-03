#!/bin/bash
WORKDIR="/opt/sherlock/"
INPUT=`apify actor:get-input | jq -r .usernames[] | xargs echo`
echo "INPUT: $INPUT"

cd $WORKDIR

python3 sherlock/sherlock.py $INPUT

for username in $INPUT; do
  echo "pushing results for username: $username"
  sed '$d' $username.txt | jo -a | jo username=$username links:=- | apify actor:push-data
done


