@echo off

REM This script runs the Docker container, mounting your host's .git-credentials file for Git authentication.

echo "--- Starting container with .git-credentials mount ---"

REM Define the path to your .git-credentials file on the host
REM IMPORTANT: Replace with the actual path to your .git-credentials file
SET GIT_CREDENTIALS_PATH=%USERPROFILE%\.git-credentials

REM Check if the .git-credentials file exists on the host
IF EXIST "%GIT_CREDENTIALS_PATH%" (
    echo Mounting .git-credentials from host: %GIT_CREDENTIALS_PATH%
    docker run -it --rm -v "%GIT_CREDENTIALS_PATH%:/home/dev/.git-credentials" my-dev-env
) ELSE (
    echo .git-credentials file not found at %GIT_CREDENTIALS_PATH%.
    echo Running container without mounting .git-credentials. You may need to configure Git credentials manually inside the container.
    docker run -it --rm my-dev-env
)

echo "--- Container exited ---"