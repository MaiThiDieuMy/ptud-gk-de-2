@echo off
setlocal

echo 🚀 Đang khởi động Django Project...

:: Kiểm tra và tạo virtual environment nếu chưa có
if not exist "venv\" (
    echo 🛠️ Đang tạo môi trường ảo (venv)...
    python -m venv venv
)

:: Kích hoạt môi trường ảo
echo 🔁 Kích hoạt môi trường ảo...
call venv\Scripts\activate

:: Cập nhật pip
echo 📦 Đang cập nhật pip...
python -m pip install --upgrade pip

:: Cài đặt các thư viện từ requirements.txt nếu có
if exist "requirements.txt" (
    echo 📂 Đang cài đặt các thư viện...
    pip install -r requirements.txt
) else (
    echo ⚠️ Không tìm thấy requirements.txt! Đang cài đặt các thư viện cơ bản...
    pip install django djangorestframework
)

:: Chạy migrations
echo 🛠️ Chạy migrate...
python manage.py migrate

:: Khởi động server Django
echo 🌍 Khởi động server Django...
python manage.py runserver

echo ✅ Django đã sẵn sàng tại: http://127.0.0.1:8000/

endlocal
pause
