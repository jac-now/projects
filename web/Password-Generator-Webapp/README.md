# Password-Generator-Webapp
A dockerized web app version of my password generator at https://github.com/jac-now/projects/blob/main/Python/passwordgenerator.py modified for use as a Web App


# Introduction

This is a simple yet secure password generator web app built using Flask (Python) and Docker. It provides a user-friendly interface to generate strong, random, and memorable passwords for various purposes.


 Features

- Generates random passwords of customizable length.
- Includes a mix of uppercase and lowercase letters, numbers, and special characters.
- User-friendly web interface for easy password generation.
- Dockerized for easy deployment and portability.


## Prerequisites

- Docker installed on your system.


## How to Build and Run

1. **Clone the Repository:**

   `git clone https://github.com/jac-now/projects/web/Password-Generator-Webapp`
   
   `cd Password-Generator-Webapp`

 
3. **Build the Docker Image:**
   
   `docker build -t password-generator .`

   
4. **Run the Container:**
   
   `docker run -d -p 5000:5000 --name password-app password-generator`


5. **Go to the Web App:**

   http://localhost:5000


6. **Generate a Password:**

Enter your desired password length (minimum 8 characters).

Click the "Generate" button.

Your new secure password will be displayed on the screen.

Important: Passwords are not stored, so be sure to copy or save your generated password before leaving the page.



## Project Structure

**app.py:** The main Flask application script.

**passwordgenerator/passwordgenerator.py:** Contains the password generation logic.

**web/index.html:** The HTML template for the web interface.

**web/style.css:** CSS styling for the web page (dark mode theme).

**Dockerfile:** Instructions for building the Docker image.

**requirements.txt:** Python package dependencies.



## Additional Information

**Security:** This is a basic password generator intended for local development and testing. For production use, consider adding more advanced security measures, such as:

**Input Validation:** Thoroughly validate user input to prevent unexpected errors or security vulnerabilities.

**HTTPS:** Serve the app over HTTPS for secure communication.

**Customization:** Feel free to customize the styling, word lists, or generation logic to fit your needs.



## Changing the Domain for Hosted Environments

When hosting the Docker container on a server or cloud platform with a custom domain name or IP address, you'll need to adjust the allowed origins for Cross-Origin Resource Sharing (CORS) in your Flask app.

1. **Modify `app.py`:**

   - Open the `app.py` file.
   - Find the line where you initialize CORS:
     CORS(app, origins=`'*'`)  # Replace `'*'` with your actual domain
   - Replace `'*'` (which allows all origins) with the actual domain name or IP address where your web app will be hosted. For example:
     CORS(app, origins='domain.com')

2. **Rebuild Docker Image:**

   - Rebuild the Docker image to include this updated configuration:
     `docker build -t password-generator .`

3. **Run the Container:**

   - Stop the existing container (if it's running):
     `docker stop password-app`
   - Run the updated container with your desired configuration:
     `docker run -d -p 5000:5000 --name password-app password-generator`

**Important Note:**

In production environments, it's strongly recommended to specify the exact origins allowed to access your API for security reasons. Only use `origins='*'` during development and testing.

**TO DO:**
   - Migrate forms to Flask Forms
   - Add Text Area form to allow adding additional word lists
   - Add more modification options to passwords
   - Add into my personal website
