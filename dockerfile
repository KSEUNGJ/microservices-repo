# Use an official Python runtime as a parent image
FROM python:3.12-slim

# Set environment variables to avoid prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends gcc libc-dev libpq-dev && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Collect static files
RUN python3 manage.py collectstatic --noinput

# Define environment variable
ENV DJANGO_SETTINGS_MODULE=config.settings
ENV DATABASE_URL=postgres://<user>:<password>@<host>:<port>/<dbname>

# Add a wait-for-it script to ensure the database is ready before migration
COPY wait-for-it.sh /wait-for-it.sh
RUN chmod +x /wait-for-it.sh

# Run the application
CMD ["/wait-for-it.sh", "<host>:<port>", "--", "sh", "-c", "python3 manage.py migrate && gunicorn --bind 0.0.0.0:8000 config.wsgi:application"]
