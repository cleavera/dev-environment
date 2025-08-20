@echo off

SET CONTAINER_NAME=my-dev-env-container

echo "--- Attempting to clean development environment ---"

docker ps -a --filter "name=%CONTAINER_NAME%" --format "{{.ID}}" | findstr /R /C:".*" >nul
IF %ERRORLEVEL% NEQ 0 (
    echo "Container '%CONTAINER_NAME%' does not exist. Nothing to clean."
    GOTO :EOF
)

docker ps --filter "name=%CONTAINER_NAME%" --format "{{.ID}}" | findstr /R /C:".*" >nul
IF %ERRORLEVEL% NEQ 0 (
    echo "Container '%CONTAINER_NAME%' exists but is not running. Removing it..."
    docker rm %CONTAINER_NAME%
    echo "Container removed. A fresh environment will be created on next 'run.cmd'."
    GOTO :EOF
)

echo "Container '%CONTAINER_NAME%' is running. Checking Git repository status..."

docker exec -it %CONTAINER_NAME% /usr/local/bin/clean-repos.sh
IF %ERRORLEVEL% EQU 0 (
    echo "All repositories are clean. Stopping and removing container..."
    docker stop %CONTAINER_NAME%
    docker rm %CONTAINER_NAME%
    echo "Container removed. A fresh environment will be created on next 'run.cmd'."
) ELSE (
    echo "Repositories are not clean. Container will NOT be removed."
    echo "Please commit and push your changes before attempting to clean."
)

echo "--- Clean process complete ---"
