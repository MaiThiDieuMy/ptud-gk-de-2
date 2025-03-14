@echo off
echo Starting Task Manager Application installation...
echo.

REM Check if Python is installed
python --version > nul 2>&1
if %errorlevel% neq 0 (
    echo Python is not installed! Please install Python 3.x and try again.
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

REM Install requirements
echo Installing required packages...
pip install -r requirements.txt

REM Run migrations
echo Running database migrations...
python manage.py migrate

REM Create static files directory and collect static files
echo Collecting static files...
python manage.py collectstatic --noinput

echo.
echo Installation complete!
echo.
echo To start the application:
echo 1. Activate the virtual environment: venv\Scripts\activate
echo 2. Run the server: python manage.py runserver
echo 3. Access the application at http://127.0.0.1:8000/
echo.
pause 