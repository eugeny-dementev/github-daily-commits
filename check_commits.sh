#!/bin/bash

# Path to the commits file
commits_file="$HOME/.config/github-daily-commits/commits.txt"

# Read the first line of the commits file
first_line=$(head -n 1 "$commits_file")

# Extract the number from the first line
number=$(echo "$first_line" | awk '{print $1}')

# Check the value and send different strings accordingly
if [ "$number" -lt 1 ]; then
    echo -n "black" | nc -4u -w0 localhost 1738
elif [ "$number" -lt 3 ]; then
    echo -n "cyan" | nc -4u -w0 localhost 1738
elif [ "$number" -lt 7 ]; then
    echo -n "green" | nc -4u -w0 localhost 1738
elif [ "$number" -lt 10 ]; then
    echo -n "yellow" | nc -4u -w0 localhost 1738
else
    echo -n "red" | nc -4u -w0 localhost 1738
fi
