#!/bin/bash

GIT_DIR="/home/dev/git"
CLEAN=true

if [ ! -d "$GIT_DIR" ]; then
    echo "Error: Git directory '$GIT_DIR' not found in container."
    exit 1
fi

echo "Checking Git repositories for unpushed changes or uncommitted modifications..."

for repo in "$GIT_DIR"/*/; do
    if [ -d "$repo/.git" ]; then
        repo_name=$(basename "$repo")
        echo "  Checking $repo_name..."
        (
            cd "$repo" || exit 1
            # Check for uncommitted changes
            if ! git status --porcelain | grep -q .; then
                # Check for unpushed commits
                # Check if upstream is set
                if git rev-parse --abbrev-ref @{u} >/dev/null 2>&1; then
                    # Check if there are unpushed commits
                    if ! git rev-list @{u}..HEAD --count >/dev/null 2>&1; then
                        echo "    $repo_name is clean and pushed."
                    else
                        echo "    $repo_name has unpushed commits."
                        CLEAN=false
                    fi
                else
                    echo "    $repo_name is clean, but no upstream branch configured."
                    # Decide if you want to consider this "dirty" for cleaning purposes.
                    # For now, we'll let it pass if there are no local changes.
                fi
            else
                echo "    $repo_name has uncommitted changes."
                CLEAN=false
            fi
        )
    fi
done

if [ "$CLEAN" = true ]; then
    echo "All Git repositories are clean and pushed."
    exit 0 # Signal clean state
else
    echo "Found unpushed changes or uncommitted modifications. Cannot clean."
    exit 1 # Signal dirty state
fi
