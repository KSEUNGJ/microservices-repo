# Use the official Python image from the Docker Hub
FROM python:3.10-slim

# Set environment variables to ensure Python outputs everything to the console
ENV PYTHONUNBUFFERED 1

# Set the working directory in the container
WORKDIR /app

# Copy the requirements file into the container
COPY requirements.txt /app/

# Install the Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code into the container
COPY . /app/

# Collect static files
RUN python manage.py collectstatic --noinput

# Expose the port that the application will run on
EXPOSE 8000

# Set environment variables for the superuser credentials
ENV DJANGO_SUPERUSER_USERNAME=cloud
ENV DJANGO_SUPERUSER_PASSWORD=dkagh
ENV DJANGO_SUPERUSER_EMAIL=cloud@gmail.com

# Command to run the Django application
CMD ["sh", "-c", "python manage.py migrate && python manage.py createsuperuser --noinput --username $DJANGO_SUPERUSER_USERNAME --email $DJANGO_SUPERUSER_EMAIL && gunicorn --bind 0.0.0.0:8000 config.wsgi:application"]
