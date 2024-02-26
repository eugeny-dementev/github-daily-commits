#!/bin/bash

# Directory of setup.sh script
script_dir=$(pwd)

# Path to the check_commits.sh script
check_script_path="$script_dir/check_commits.sh"

# Check if check_commits.sh exists
if [ ! -f "$check_script_path" ]; then
    echo "Error: check_commits.sh not found."
    exit 1
fi

# Add execute permissions to check_commits.sh if not set
if [ ! -x "$check_script_path" ]; then
    chmod +x "$check_script_path"
    echo "Added execute permissions to check_commits.sh."
fi

# Check if the script is already set in the crontab
if ! crontab -l | grep -q "$check_script_path"; then
    # Add the script to the crontab to run every 10 minutes
    (crontab -l ; echo "*/10 * * * * $check_script_path") | crontab -
    echo "check_commits.sh added to crontab to run every 10 minutes."
else
    echo "check_commits.sh is already set in crontab."
fi
