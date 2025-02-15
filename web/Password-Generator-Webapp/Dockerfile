FROM python:3.11-slim

# Install dependencies
WORKDIR /app
COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

#Copy necessary files
COPY . /app
COPY web/abm.png /app/web/abm.png

# Expose the port for Flask
EXPOSE 5000

# Run the application
CMD ["flask", "run", "--host=0.0.0.0"]

