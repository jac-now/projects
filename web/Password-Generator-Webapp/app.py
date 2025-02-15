from flask import Flask, render_template, request
from flask_cors import CORS
from passwordgenerator.passwordgenerator import generate_password
import logging

app = Flask(__name__, template_folder='web', static_folder='web', static_url_path='')
CORS(app, origins='*')

@app.route('/', methods=['GET', 'POST'])
def index():
    password = None
    error_message = None  # Initialize error message
    if request.method == 'POST':
        try:
            length_str = request.form['length']
            if not length_str:
                raise ValueError("Password length cannot be empty.")
            length = int(length_str)
            if length < 8:
                raise ValueError("Password length must be at least 8 characters.")
            password = generate_password(length)
            logging.info("Length = %d, password = %s", length, password)
        except ValueError as e:
            error_message = str(e)  # Store the error message
    return render_template('index.html', password=password, error_message=error_message)

if __name__ == '__main__':
    app.run(debug=True, host="0.0.0.0", port=5000)
