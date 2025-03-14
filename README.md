# Task Manager Application

A Django-based task management system that allows users to manage their tasks with features like task status tracking, creation time, and completion time. The application supports two types of users: administrators and regular users.

## Features
- User authentication (Admin and Regular users)
- Task management (Create, Read, Update, Delete)
- Avatar upload support
- Task status tracking
- Overdue task warnings
- Single Column Card Layout

## Personal Information
- Student ID: [Your Student ID]
- Name: [Your Name]
- Class: [Your Class]

## Installation Instructions

1. Clone the repository:
```bash
git clone https://github.com/yourusername/ptud-gk-de-2.git
cd ptud-gk-de-2
```

2. Create and activate a virtual environment:
```bash
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
```

3. Install required packages:
```bash
pip install -r requirements.txt
```

4. Apply database migrations:
```bash
python manage.py migrate
```

5. Create a superuser (admin):
```bash
python manage.py createsuperuser
```

6. Run the development server:
```bash
python manage.py runserver
```

7. Access the application at http://127.0.0.1:8000/

## Technologies Used
- Python 3.x
- Django 4.x
- HTML5
- CSS3
- SQLite (default database) 