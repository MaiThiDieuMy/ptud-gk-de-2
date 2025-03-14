@echo off
setlocal enabledelayedexpansion

echo ===============================
echo  Task Manager Installation
echo ===============================
echo.

REM Kiểm tra xem Python có trong PATH không
where python > nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Python is not installed or not found in PATH!
    echo Please install Python 3.x and try again.
    pause
    exit /b 1
)

REM Kiểm tra xem requirements.txt có tồn tại không
if not exist "requirements.txt" (
    echo [ERROR] requirements.txt not found!
    echo Please ensure you are in the correct directory.
    pause
    exit /b 1
)

REM Xóa môi trường ảo nếu có lỗi trước đó
if exist "venv" (
    echo [INFO] Deleting old virtual environment...
    rmdir /s /q venv
)

REM Tạo môi trường ảo mới
echo [INFO] Creating virtual environment...
python -m venv venv
if %errorlevel% neq 0 (
    echo [ERROR] Failed to create virtual environment!
    pause
    exit /b 1
)

REM Kích hoạt môi trường ảo
echo [INFO] Activating virtual environment...
call venv\Scripts\activate.bat
if %errorlevel% neq 0 (
    echo [ERROR] Failed to activate virtual environment!
    pause
    exit /b 1
)

REM Cập nhật pip, setuptools, wheel để tránh lỗi
echo [INFO] Upgrading pip, setuptools, and wheel...
venv\Scripts\python -m pip install --upgrade pip setuptools wheel
if %errorlevel% neq 0 (
    echo [ERROR] Failed to upgrade pip, setuptools, or wheel!
    pause
    exit /b 1
)

REM Cài đặt Pillow với wheel để tránh lỗi build
echo [INFO] Installing Pillow...
venv\Scripts\pip install --no-cache-dir Pillow==10.4.0
if %errorlevel% neq 0 (
    echo [ERROR] Failed to install Pillow! Retrying with alternative method...
    venv\Scripts\pip install --no-cache-dir --no-binary :all: Pillow
    if %errorlevel% neq 0 (
        echo [ERROR] Pillow installation failed completely!
        pause
        exit /b 1
    )
)

REM Cài đặt Django
echo [INFO] Installing Django...
venv\Scripts\pip install Django==5.0
if %errorlevel% neq 0 (
    echo [ERROR] Failed to install Django!
    pause
    exit /b 1
)

REM Cài đặt các package còn lại
echo [INFO] Installing other dependencies...
venv\Scripts\pip install django-crispy-forms==2.1
venv\Scripts\pip install crispy-bootstrap5==2023.10
venv\Scripts\pip install python-dotenv==1.0.0
venv\Scripts\pip install requests==2.31.0
venv\Scripts\pip install whitenoise==6.6.0

REM Chạy migration database
echo [INFO] Running database migrations...
venv\Scripts\python manage.py migrate
if %errorlevel% neq 0 (
    echo [ERROR] Database migration failed!
    pause
    exit /b 1
)

REM Thu thập static files
echo [INFO] Collecting static files...
venv\Scripts\python manage.py collectstatic --noinput
if %errorlevel% neq 0 (
    echo [ERROR] Collecting static files failed!
    pause
    exit /b 1
)

echo.
echo ===============================
echo  Installation Completed!
echo ===============================
echo.
echo Next Steps:
echo ---------------------------------
echo 1. Activate the virtual environment:
echo    venv\Scripts\activate
echo.
echo 2. Run the Django server:
echo    venv\Scripts\python manage.py runserver
echo.
echo 3. Access the application at:
echo    http://127.0.0.1:8000/
echo.
pause
cmd /k
