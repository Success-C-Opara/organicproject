# Use the latest official Python runtime as a parent image
FROM python:latest

# Set the working directory inside the container
WORKDIR /usr/src/app

# Copy requirements.txt first to leverage Docker cache
COPY requirements.txt .

# Install dependencies from requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code into the container
COPY . .

# Set the environment variable for Django settings
ENV DJANGO_SETTINGS_MODULE=myproject.settings

# Expose port 8000 for the Django application
EXPOSE 8000

# Use gunicorn as the WSGI server (recommended for production)
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "myproject.wsgi:application"]
