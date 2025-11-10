# Stage 1: Build Stage
FROM python:3.9-slim-buster AS builder

# Set working directory
WORKDIR /app

# Copy dependency files
COPY requirements.txt .

# Install dependencies (use --no-cache-dir for smaller image size)
RUN pip install --no-cache-dir -r requirements.txt

# Stage 2: Production Stage
FROM python:3.9-slim-buster

# Expose the application port
EXPOSE 8080

# Set working directory
WORKDIR /app

# Copy installed dependencies from the builder stage
COPY --from=builder /usr/local/lib/python3.9/site-packages/ /usr/local/lib/python3.9/site-packages/

# Copy the application code
COPY app.py .

# Define the command to run the application using gunicorn for production
# Listen on 0.0.0.0 and use 2 workers
CMD ["gunicorn", "--bind", "0.0.0.0:8080", "app:app"]