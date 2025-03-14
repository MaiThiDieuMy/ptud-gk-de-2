@echo off
echo Starting Task Manager Application installation...
echo Current working directory: %CD%
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
    echo Please ensure you are in the correct directory: %CD%
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
call "%CD%\venv\Scripts\activate.bat"
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

REM Upgrade pip and install build dependencies
echo Upgrading pip and installing build dependencies...
venv\Scripts\python -m pip install --upgrade pip setuptools wheel
if %errorlevel% neq 0 (
    echo Warning: Failed to upgrade pip or install build dependencies.
    echo This might cause issues with package installation.
    pause
)

REM Install Pillow first as it's a critical dependency
echo Installing Pillow...
venv\Scripts\pip install --only-binary :all: Pillow==10.4.0
if %errorlevel% neq 0 (
    echo Trying alternative Pillow installation method...
    venv\Scripts\pip install --no-cache-dir Pillow==10.4.0
    if %errorlevel% neq 0 (
        echo Error: Failed to install Pillow! This is required for the application.
        echo Please ensure you have Microsoft Visual C++ Build Tools installed.
        pause
        exit /b 1
    )
)

REM Install Django next as it's the main framework
echo Installing Django...
venv\Scripts\pip install Django==5.0
if %errorlevel% neq 0 (
    echo Error: Failed to install Django! This is required for the application.
    pause
    exit /b 1
)

REM Install remaining packages
echo Installing remaining packages...
venv\Scripts\pip install django-crispy-forms==2.1
venv\Scripts\pip install crispy-bootstrap5==2023.10
venv\Scripts\pip install python-dotenv==1.0.0
venv\Scripts\pip install requests==2.31.0
venv\Scripts\pip install whitenoise==6.6.0

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
echo 1. Ensure you are in the virtual environment:
echo    %CD%\venv\Scripts\activate
echo.
echo 2. Run database migrations with:
echo    %CD%\venv\Scripts\python manage.py migrate
echo.
echo 3. Collect static files with:
echo    %CD%\venv\Scripts\python manage.py collectstatic
echo.
echo 5. Start the development server with:
echo    %CD%\venv\Scripts\python manage.py runserver

pause
