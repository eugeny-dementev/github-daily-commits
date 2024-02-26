#!/bin/bash

# Get the directory of the setup.sh script
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Find pull_daily_commits.js in the current directory
pull_script_path="$script_dir/pull_daily_commits.js"

# Check if pull_daily_commits.js exists
if [ ! -f "$pull_script_path" ]; then
    echo "Error: pull_daily_commits.js not found in the current directory."
    exit 1
fi

# Add execute permissions to pull_daily_commits.js if not set
if [ ! -x "$pull_script_path" ]; then
    chmod +x "$pull_script_path"
    echo "Added execute permissions to pull_daily_commits.js."
fi

# Check if pull_daily_commits.js is already set in the crontab
if ! crontab -l | grep -q "$pull_script_path"; then
    # Add the script to the crontab to run once per hour
    (crontab -l ; echo "5 * * * * cd $script_dir && ./pull_daily_commits.js") | crontab -
    echo "pull_daily_commits.js added to crontab to run once per hour with CWD set to $script_dir."
else
    echo "pull_daily_commits.js is already set in crontab."
fi
