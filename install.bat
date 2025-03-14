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

REM Check if requirements.txt exists
if not exist "requirements.txt" (
    echo Error: requirements.txt not found!
    echo Please ensure you are in the correct directory.
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

REM Upgrade pip to latest version
echo Upgrading pip to latest version...
venv\Scripts\python -m pip install --upgrade pip
if %errorlevel% neq 0 (
    echo Warning: Failed to upgrade pip, continuing with installation...
)

REM Install requirements one by one to better handle errors
echo Installing required packages...
for /F "tokens=*" %%A in (requirements.txt) do (
    echo Installing %%A...
    venv\Scripts\pip install %%A
    if %errorlevel% neq 0 (
        echo Warning: Failed to install %%A, continuing with other packages...
    )
)

REM Run migrations
echo Running database migrations...
venv\Scripts\python manage.py migrate

REM Create static files directory and collect static files
echo Collecting static files...
venv\Scripts\python manage.py collectstatic --noinput

echo.
echo Installation completed!
echo.
echo Note: If there were any package installation warnings above,
echo you may need to manually install those packages.
echo.
echo Next steps to set up the application:
echo.
echo 1. Activate the virtual environment with:
echo    venv\Scripts\activate
echo.
echo 2. Run database migrations with:
echo    venv\Scripts\python manage.py migrate
echo.
echo 3. Collect static files with:
echo    venv\Scripts\python manage.py collectstatic
echo.
echo 4. Create an admin account (optional) with:
echo    venv\Scripts\python manage.py createsuperuser
echo.
echo 5. Start the development server with:
echo    venv\Scripts\python manage.py runserver
echo.
echo Once the server is running, access the application at:
echo http://127.0.0.1:8000/
echo.
pause 
