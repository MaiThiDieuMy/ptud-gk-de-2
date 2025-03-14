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
python -m pip install --upgrade pip setuptools wheel
pip install -r requirements.txt

REM Run database migrations
echo.
echo Running database migrations...
python manage.py migrate

REM Collect static files
echo.
echo Collecting static files...
python manage.py collectstatic --noinput

echo.
python manage.py runserver
echo.
pause
