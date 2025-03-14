@echo off
echo Installing Task Manager Application...

:: Check if Python is installed
python --version > nul 2>&1
if errorlevel 1 (
    echo Python is not installed! Please install Python 3.x and try again.
    exit /b 1
)

:: Check if pip is installed
pip --version > nul 2>&1
if errorlevel 1 (
    echo pip is not installed! Please install pip and try again.
    exit /b 1
)

:: Create virtual environment
echo Creating virtual environment...
python -m venv venv
call venv\Scripts\activate.bat

:: Install requirements
echo Installing dependencies...
pip install -r requirements.txt

:: Create .env file if it doesn't exist
if not exist .env (
    echo Creating .env file...
    echo SECRET_KEY=your-secret-key-here > .env
    echo DEBUG=True >> .env
    echo ALLOWED_HOSTS=localhost,127.0.0.1 >> .env
)

:: Run migrations
echo Running database migrations...
python manage.py makemigrations
python manage.py migrate

:: Create media directory
echo Creating media directory...
mkdir media\avatars 2> nul

:: Collect static files
echo Collecting static files...
python manage.py collectstatic --noinput

echo.
echo Installation completed successfully!
echo.
echo To start the development server:
echo 1. Activate the virtual environment: venv\Scripts\activate
python manage.py runserver

