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

# Copy the entrypoint script into the container
COPY entrypoint.py /app/entrypoint.py

# Expose the port that the application will run on
EXPOSE 8000

# Command to run the entrypoint script
CMD ["python", "entrypoint.py"]
