@echo off
echo Starting Task Manager Application installation...
echo.

REM Check if Python is installed and get its path
where python > nul 2>&1
if %errorlevel% neq 0 (
    echo Python is not installed or not in PATH! Please install Python 3.x and try again.
    pause
    exit /b 1
)

REM Create virtual environment if it doesn't exist
if not exist "venv" (
    echo Creating virtual environment...
    python -m venv venv
    if %errorlevel% neq 0 (
        echo Failed to create virtual environment!
        pause
        exit /b 1
    )
)

REM Activate virtual environment
echo Activating virtual environment...
call venv\Scripts\activate.bat
if %errorlevel% neq 0 (
    echo Failed to activate virtual environment!
    pause
    exit /b 1
)

REM Verify virtual environment activation
venv\Scripts\python --version > nul 2>&1
if %errorlevel% neq 0 (
    echo Virtual environment activation failed!
    pause
    exit /b 1
)

REM Install requirements
echo Installing required packages...
venv\Scripts\pip install -r requirements.txt
if %errorlevel% neq 0 (
    echo Failed to install required packages!
    pause
    exit /b 1
)

REM Run migrations
echo Running database migrations...
python manage.py migrate

REM Create static files directory and collect static files
echo Collecting static files...
python manage.py collectstatic --noinput

echo.
echo Installation complete!
echo.
echo Next steps:
echo 1. Activate the virtual environment:
echo    venv\Scripts\activate
echo.
echo 2. Run database migrations:
echo    python manage.py migrate
echo.
echo 3. Create static files:
echo    python manage.py collectstatic
echo.
echo 4. Create an admin account (optional):
echo    python manage.py createsuperuser
echo.
echo 5. Start the development server:
echo    python manage.py runserver
echo.
echo Once the server is running, access the application at:
echo http://127.0.0.1:8000/
echo.
pause 