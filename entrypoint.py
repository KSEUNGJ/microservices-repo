# entrypoint.py
import os
import django
from django.contrib.auth import get_user_model
from django.core.management import execute_from_command_line

os.environ.setdefault("DJANGO_SETTINGS_MODULE", "config.settings")
django.setup()

User = get_user_model()

def create_superuser_if_not_exists():
    username = os.environ.get("DJANGO_SUPERUSER_USERNAME")
    email = os.environ.get("DJANGO_SUPERUSER_EMAIL")
    password = os.environ.get("DJANGO_SUPERUSER_PASSWORD")
    
    if not User.objects.filter(username=username).exists():
        User.objects.create_superuser(username, email, password)
        print(f"Superuser {username} created successfully.")
    else:
        print(f"Superuser {username} already exists.")

if __name__ == "__main__":
    execute_from_command_line(["manage.py", "migrate"])
    create_superuser_if_not_exists()
    execute_from_command_line(["manage.py", "runserver", "0.0.0.0:8000"])
