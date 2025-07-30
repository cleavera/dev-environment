@echo off

REM This script runs the Docker container, mounting your host's .git-credentials file for Git authentication.

echo "--- Starting container with .git-credentials mount ---"

REM Define the path to your .git-credentials file on the host
REM IMPORTANT: Replace with the actual path to your .git-credentials file
SET GIT_CREDENTIALS_PATH=%USERPROFILE%\.git-credentials
SET NPMRC_PATH=%USERPROFILE%\.npmrc

SET GIT_CHECKOUT_CSV_PATH=%~dp0\git-checkout.csv

REM Check if the .git-credentials file exists on the host
IF EXIST "%NPMRC_PATH%" (
    IF EXIST "%GIT_CREDENTIALS_PATH%" (
        echo Mounting .git-credentials from host: %GIT_CREDENTIALS_PATH%
        IF EXIST "%GIT_CHECKOUT_CSV_PATH%" (
            echo Mounting git-checkout.csv from host: %GIT_CHECKOUT_CSV_PATH%
            docker run -it --rm -v "%GIT_CREDENTIALS_PATH%:/home/dev/.git-credentials" -v "%GIT_CHECKOUT_CSV_PATH%:/tmp/git-checkout.csv" -v "%NPMRC_PATH%:/home/dev/.npmrc" my-dev-env
        ) ELSE (
            echo git-checkout.csv not found at %GIT_CHECKOUT_CSV_PATH%. Running without mounting.
            docker run -it --rm -v "%GIT_CREDENTIALS_PATH%:/home/dev/.git-credentials" -v "%NPMRC_PATH%:/home/dev/.npmrc" my-dev-env
        )
    ) ELSE (
        echo .git-credentials file not found at %GIT_CREDENTIALS_PATH%. You may need to configure Git credentials manually inside the container.
        IF EXIST "%GIT_CHECKOUT_CSV_PATH%" (
            echo Mounting git-checkout.csv from host: %GIT_CHECKOUT_CSV_PATH%
            docker run -it --rm -v "%GIT_CHECKOUT_CSV_PATH%:/tmp/git-checkout.csv"-v "%NPMRC_PATH%:/home/dev/.npmrc" my-dev-env
        ) ELSE (
            echo git-checkout.csv not found at %GIT_CHECKOUT_CSV_PATH%. Running without mounting.
            docker run -it --rm -v "%NPMRC_PATH%:/home/dev/.npmrc" my-dev-env
        )
    )
) ELSE (
    IF EXIST "%GIT_CREDENTIALS_PATH%" (
        echo Mounting .git-credentials from host: %GIT_CREDENTIALS_PATH%
        IF EXIST "%GIT_CHECKOUT_CSV_PATH%" (
            echo Mounting git-checkout.csv from host: %GIT_CHECKOUT_CSV_PATH%
            docker run -it --rm -v "%GIT_CREDENTIALS_PATH%:/home/dev/.git-credentials" -v "%GIT_CHECKOUT_CSV_PATH%:/tmp/git-checkout.csv" my-dev-env
        ) ELSE (
            echo git-checkout.csv not found at %GIT_CHECKOUT_CSV_PATH%. Running without mounting.
            docker run -it --rm -v "%GIT_CREDENTIALS_PATH%:/home/dev/.git-credentials" my-dev-env
        )
    ) ELSE (
        echo .git-credentials file not found at %GIT_CREDENTIALS_PATH%. You may need to configure Git credentials manually inside the container.
        IF EXIST "%GIT_CHECKOUT_CSV_PATH%" (
            echo Mounting git-checkout.csv from host: %GIT_CHECKOUT_CSV_PATH%
            docker run -it --rm -v "%GIT_CHECKOUT_CSV_PATH%:/tmp/git-checkout.csv" my-dev-env
        ) ELSE (
            echo git-checkout.csv not found at %GIT_CHECKOUT_CSV_PATH%. Running without mounting.
            docker run -it --rm my-dev-env
        )
    )
)

echo "--- Container exited ---"
