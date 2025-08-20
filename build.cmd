@echo off

FOR /F "usebackq tokens=*" %%g IN (`git config --global user.name`) DO set GIT_USER_NAME=%%g
FOR /F "usebackq tokens=*" %%g IN (`git config --global user.email`) DO set GIT_USER_EMAIL=%%g

echo "--- Building with Git identity ---"
echo "Name: %GIT_USER_NAME%"
echo "Email: %GIT_USER_EMAIL%"
echo "----------------------------------"

docker build --build-arg GIT_USER_NAME="%GIT_USER_NAME%" --build-arg GIT_USER_EMAIL="%GIT_USER_EMAIL%" -t my-dev-env -f "%~dp0\Dockerfile" "%~dp0"

echo "--- Build complete ---"
