#!/bin/bash

SENTINEL_FILE="/home/dev/.first_run_complete"

# Check if this is the first run
if [ ! -f "$SENTINEL_FILE" ]; then
    echo "First run detected. Running git-checkout.sh..."
    /usr/local/bin/git-checkout.sh
    echo "Forcing password change for 'dev' user..."
    sudo -v # This will trigger the password change prompt
    touch "$SENTINEL_FILE"
fi

# Execute the main command (CMD) from the Dockerfile
exec "$@"
