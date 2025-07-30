#!/bin/bash

# Ensure the target directory exists
mkdir -p /home/dev/git
cd /home/dev/git || exit 1

# Check if the git-checkout.csv file is mounted
if [ ! -f /tmp/git-checkout.csv ]; then
    echo "git-checkout.csv not found. Skipping repository checkout."
    exit 0
fi

echo "Cloning repositories from git-checkout.csv..."

# Read the CSV file line by line
while IFS= read -r repo_url; do
    if [ -z "$repo_url" ]; then
        continue # Skip empty lines
    fi

    repo_name=$(basename "$repo_url" .git)

    if [ -d "$repo_name" ]; then
        echo "Repository $repo_name already exists. Skipping clone."
    else
        echo "Cloning $repo_url into $repo_name..."
        git clone "$repo_url" "$repo_name"
        if [ $? -ne 0 ]; then
            echo "Error cloning $repo_url. Please check the URL and your Git credentials."
        fi
    fi
done < /tmp/git-checkout.csv

echo "Repository checkout complete."
