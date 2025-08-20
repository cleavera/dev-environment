@echo off

echo "--- Starting container ---"

SET GIT_CREDENTIALS_PATH=%USERPROFILE%\.git-credentials
SET NPMRC_PATH=%USERPROFILE%\.npmrc

SET GIT_CHECKOUT_CSV_PATH=%~dp0\git-checkout.csv

IF EXIST "%NPMRC_PATH%" (
    IF EXIST "%GIT_CREDENTIALS_PATH%" (
        echo Mounting .git-credentials from host: %GIT_CREDENTIALS_PATH%
        IF EXIST "%GIT_CHECKOUT_CSV_PATH%" (
            echo Mounting git-checkout.csv from host: %GIT_CHECKOUT_CSV_PATH%
            docker run -it -v "%GIT_CREDENTIALS_PATH%:/home/dev/.git-credentials" -v "%GIT_CHECKOUT_CSV_PATH%:/tmp/git-checkout.csv" -v "%NPMRC_PATH%:/home/dev/.npmrc" my-dev-env
        ) ELSE (
            echo git-checkout.csv not found at %GIT_CHECKOUT_CSV_PATH%. Running without mounting.
            docker run -it -v "%GIT_CREDENTIALS_PATH%:/home/dev/.git-credentials" -v "%NPMRC_PATH%:/home/dev/.npmrc" my-dev-env
        )
    ) ELSE (
        echo .git-credentials file not found at %GIT_CREDENTIALS_PATH%. You may need to configure Git credentials manually inside the container.
        IF EXIST "%GIT_CHECKOUT_CSV_PATH%" (
            echo Mounting git-checkout.csv from host: %GIT_CHECKOUT_CSV_PATH%
            docker run -it -v "%GIT_CHECKOUT_CSV_PATH%:/tmp/git-checkout.csv"-v "%NPMRC_PATH%:/home/dev/.npmrc" my-dev-env
        ) ELSE (
            echo git-checkout.csv not found at %GIT_CHECKOUT_CSV_PATH%. Running without mounting.
            docker run -it -v "%NPMRC_PATH%:/home/dev/.npmrc" my-dev-env
        )
    )
) ELSE (
    IF EXIST "%GIT_CREDENTIALS_PATH%" (
        echo Mounting .git-credentials from host: %GIT_CREDENTIALS_PATH%
        IF EXIST "%GIT_CHECKOUT_CSV_PATH%" (
            echo Mounting git-checkout.csv from host: %GIT_CHECKOUT_CSV_PATH%
            docker run -it -v "%GIT_CREDENTIALS_PATH%:/home/dev/.git-credentials" -v "%GIT_CHECKOUT_CSV_PATH%:/tmp/git-checkout.csv" my-dev-env
        ) ELSE (
            echo git-checkout.csv not found at %GIT_CHECKOUT_CSV_PATH%. Running without mounting.
            docker run -it -v "%GIT_CREDENTIALS_PATH%:/home/dev/.git-credentials" my-dev-env
        )
    ) ELSE (
        echo .git-credentials file not found at %GIT_CREDENTIALS_PATH%. You may need to configure Git credentials manually inside the container.
        IF EXIST "%GIT_CHECKOUT_CSV_PATH%" (
            echo Mounting git-checkout.csv from host: %GIT_CHECKOUT_CSV_PATH%
            docker run -it -v "%GIT_CHECKOUT_CSV_PATH%:/tmp/git-checkout.csv" my-dev-env
        ) ELSE (
            echo git-checkout.csv not found at %GIT_CHECKOUT_CSV_PATH%. Running without mounting.
            docker run -it my-dev-env
        )
    )
)

echo "--- Container exited ---"
