# Password Generator Web App

This is a dockerized web app version of my password generator, modified for use as a web application. It provides a simple and secure way to generate strong, random, and memorable passwords.

## Introduction

This web app is built with Flask and Docker, offering a user-friendly interface for generating passwords. It's designed to be easy to use and deploy.

## Features

- **Customizable Length**: Generate passwords of a specified length.
- **Secure and Random**: Passwords include a mix of uppercase and lowercase letters, numbers, and special characters.
- **User-Friendly Interface**: A clean and simple web interface for easy password generation.
- **Dockerized**: The application is containerized with Docker for easy deployment and portability.

## Prerequisites

- Docker must be installed on your system.

## How to Build and Run

1. **Clone the Repository**:

   ```bash
   git clone https://github.com/jac-now/projects/web/Password-Generator-Webapp
   cd Password-Generator-Webapp
   ```

2. **Build the Docker Image**:

   ```bash
   docker build -t password-generator .
   ```

3. **Run the Docker Container**:

   ```bash
   docker run -d -p 5000:5000 --name password-app password-generator
   ```

4. **Access the Web App**:

   Open your web browser and navigate to `http://localhost:5000`.

5. **Generate a Password**:

   - Enter your desired password length (minimum 8 characters).
   - Click the "Generate" button.
   - Your new secure password will be displayed on the screen.

   **Important**: Passwords are not stored, so be sure to copy or save your generated password before leaving the page.

## Project Structure

- `app.py`: The main Flask application script.
- `passwordgenerator/passwordgenerator.py`: Contains the password generation logic.
- `web/index.html`: The HTML template for the web interface.
- `web/style.css`: The CSS styling for the web page.
- `Dockerfile`: The instructions for building the Docker image.
- `requirements.txt`: The Python package dependencies.

## Additional Information

### Security

This is a basic password generator intended for local development and testing. For production use, consider adding more advanced security measures, such as:

- **Input Validation**: Thoroughly validate user input to prevent unexpected errors or security vulnerabilities.
- **HTTPS**: Serve the app over HTTPS for secure communication.

### Customization

Feel free to customize the styling, word lists, or generation logic to fit your needs.

### Changing the Domain for Hosted Environments

When hosting the Docker container on a server or cloud platform with a custom domain name or IP address, you'll need to adjust the allowed origins for Cross-Origin Resource Sharing (CORS) in your Flask app.

1. **Modify `app.py`**:

   - Open the `app.py` file.
   - Find the line where you initialize CORS:
     ```python
     CORS(app, origins='*')  # Replace '*' with your actual domain
     ```
   - Replace `'*'` (which allows all origins) with the actual domain name or IP address where your web app will be hosted. For example:
     ```python
     CORS(app, origins='https://your-domain.com')
     ```

2. **Rebuild the Docker Image**:

   - Rebuild the Docker image to include this updated configuration:
     ```bash
     docker build -t password-generator .
     ```

3. **Run the Container**:

   - Stop the existing container (if it's running):
     ```bash
     docker stop password-app
     ```
   - Run the updated container with your desired configuration:
     ```bash
     docker run -d -p 5000:5000 --name password-app password-generator
     ```

**Important Note**: In production environments, it's strongly recommended to specify the exact origins allowed to access your API for security reasons. Only use `origins='*'` during development and testing.

## To-Do

- [ ] Migrate forms to Flask-WTF for better form handling and validation.
- [ ] Add a text area form to allow users to add their own word lists.
- [ ] Add more customization options for password generation.
- [ ] Keep the input password length value in the field after generating a password.
- [ ] Integrate this password generator into my personal website.