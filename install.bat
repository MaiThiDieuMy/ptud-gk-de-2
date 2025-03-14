@echo off
echo Starting Task Manager Application installation...
echo.

REM Check if Python is installed and get its path
python --version > nul 2>&1
if %errorlevel% neq 0 (
    echo Python is not installed or not in PATH! Please install Python 3.x and try again.
    pause
    exit /b 1
)

REM Create virtual environment if it doesn't exist
if not exist "venv" (
    echo Creating virtual environment...
    python -m venv venv
)

REM Activate virtual environment
echo Activating virtual environment...
call venv\Scripts\activate.bat

REM Install required packages
echo Installing required packages...
python -m pip install --upgrade pip
pip install -r requirements.txt

echo.
echo Installation completed!
echo.
echo Next steps:
echo 1. Run database migrations:
echo    python manage.py migrate
echo.
echo 2. Create an admin account (optional):
echo    python manage.py createsuperuser
echo.
echo 3. Start the development server:
echo    python manage.py runserver
echo.
echo Once the server is running, access the application at:
echo http://127.0.0.1:8000/
echo.
pause 