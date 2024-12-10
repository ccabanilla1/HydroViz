@echo off
SETLOCAL EnableDelayedExpansion

echo Starting HydroViz...

REM Store the backend directory
set "BACKEND_DIR=%CD%"

REM Check if we're in the backend directory
IF NOT EXIST manage.py (
    echo Please run this script from the Django backend directory
    exit /b 1
)

REM Create and activate virtual environment if it doesn't exist
IF NOT EXIST venv (
    echo Creating virtual environment...
    python -m venv venv
)

REM Activate virtual environment
call venv\Scripts\activate.bat

REM Install dependencies
echo Installing Python dependencies...
pip install -r requirements.txt

REM Start Django server in a new window
echo Starting Django server...
start "Django Server" cmd /k "python manage.py runserver"

REM Wait a moment for Django to start
timeout /t 5

REM Start Flutter app in a new window
echo Starting Flutter Windows app...
start "Flutter App" cmd /k "cd ..\ui && flutter clean && flutter pub get && flutter run -d windows"

echo HydroViz started successfully!
echo The Django server and Flutter app are running in separate windows.
echo Press any key to exit this window.
pause