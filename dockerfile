# Use an official Python runtime as a parent image
FROM python:3.12-slim

# Set the working directory in the container
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libpq-dev \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Ensure the entrypoint script is executable
RUN chmod +x /app/entrypoint.sh

# Define environment variable
ENV DJANGO_SETTINGS_MODULE=config.settings

# Run the entrypoint script
CMD ["/app/entrypoint.sh"]
