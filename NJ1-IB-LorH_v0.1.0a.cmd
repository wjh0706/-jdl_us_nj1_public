@echo off
setlocal enabledelayedexpansion

REM Set hardcoded password
set password=jdnj1

REM Check if Python is installed
python --version >nul 2>&1 || (
    echo Python is not installed. Installing Python...
    REM Download and install Python
    powershell -Command "Invoke-WebRequest -Uri 'https://www.python.org/ftp/python/3.10.11/python-3.10.11-amd64.exe' -OutFile 'python-installer.exe'"
    start /wait python-installer.exe /quiet InstallAllUsers=1 PrependPath=1
    del python-installer.exe
    echo Python installed. Please restart this command window to start the bot.
    pause
    exit /b
)

REM Delete existing requirements file if it exists
del /q NJ1-IB-LorH_v0.1.0a_requirements.txt 2>nul

REM Pull latest NJ1-IB-LorH_v0.1.0a_requirements.txt from GitHub using PowerShell
powershell -Command "Invoke-WebRequest -Uri 'https://github.com/wjh0706/jdl_us_nj1_public/raw/main/NJ1-IB-LorH_v0.1.0a_requirements.txt' -OutFile 'NJ1-IB-LorH_v0.1.0a_requirements.txt'" >nul

REM Install Python packages from the requirements file
pip install -r NJ1-IB-LorH_v0.1.0a_requirements.txt >nul

REM Delete the requirements file after installation
del /q NJ1-IB-LorH_v0.1.0a_requirements.txt 2>nul

REM Delete existing files if they exist
del /q NJ1-IB-LorH_v0.1.0a.pkl 2>nul
del /q decrypt_and_run.py 2>nul

REM Pull latest decrypt_and_run.py and NJ1-IB-LorH_v0.1.0a.pkl from GitHub using PowerShell
powershell -Command "Invoke-WebRequest -Uri 'https://github.com/wjh0706/jdl_us_nj1_public/raw/main/decrypt_and_run.py' -OutFile 'decrypt_and_run.py'" >nul
powershell -Command "Invoke-WebRequest -Uri 'https://github.com/wjh0706/jdl_us_nj1_public/raw/main/NJ1-IB-LorH_v0.1.0a.pkl' -OutFile 'NJ1-IB-LorH_v0.1.0a.pkl'" >nul

REM Display message while Python script runs in the background. User needs to press Ctrl+C twice to exit the script.
echo The bot is running. To stop the bot, close this command window or press Ctrl+C twice.

REM Run the Python script with hardcoded password (redirecting output to nul to suppress Python's output)
python decrypt_and_run.py NJ1-IB-LorH_v0.1.0a.pkl %password% >nul
