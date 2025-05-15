# Stage 1: Base build stage

FROM python:3.12-slim AS builder

# Step 2: Install system dependencies required for building packages
RUN apt-get update && apt-get install -y \
# MySQL headers for mysqlclient
    default-libmysqlclient-dev \ 
# Compiler tools like gcc and make
    build-essential \    
# Tool to find libraries and headers         
    pkg-config \    
# Clean up to reduce image size              
    && rm -rf /var/lib/apt/lists/*  

# Create the app directory

RUN mkdir /app

# Set the working directory

WORKDIR /app

# Set environment variables to optimize Python
#prevents .pyc files from being created in image = takes up unnecessary space
#presents logs in case of debugging situations

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Upgrade pip and install dependencies

RUN pip install --upgrade pip

# Copy the requirements file first (better caching)

COPY requirements.txt /app/

# Install Python dependencies

RUN pip install --no-cache-dir -r requirements.txt
  

# Stage 2: Production stage

FROM python:3.12-slim

#The -m is used to create the user under the home directory = easily identifiable by python tools when looking it local cache for necessary files
#The -r is used to mark 'appuser' as a system user rather than a human one
#Ownership is given to app user within this app directory

RUN useradd -m -r appuser && \  
   mkdir /app && \
   chown -R appuser /app

# Copy the Python dependencies from the builder stage

COPY --from=builder /usr/local/lib/python3.12/site-packages/ /usr/local/lib/python3.12/site-packages/
COPY --from=builder /usr/local/bin/ /usr/local/bin/


# Set the working directory

WORKDIR /app

# All copied files are immediately owned by the new user

COPY --chown=appuser\:appuser . .

# Set environment variables to optimize Python

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Switch to non-root user
#Essentially this is done to prevent potential attackers from having full access of the app if it was compromised

USER appuser

# Expose the application port

EXPOSE 8000

# Start the application using Python

CMD ["gunicorn", "--workers=3", "--bind=0.0.0.0:8000", "mysite.wsgi:application"]




