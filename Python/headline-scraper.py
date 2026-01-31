import requests
from bs4 import BeautifulSoup
import smtplib
import os  # Added just in case you want to expand later

# --- Configuration ---
# (Replace these with your actual details)
USER_EMAIL = "me@gmail.com"
EMAIL_PASSWORD = "my_app_password" # Remember: Use an App Password, not your main password
RECIPIENT_EMAIL = "me@gmail.com"
URL = "https://news.ycombinator.com/"
FILE_NAME = "headlines.txt"

# --- Part 1: The Robust Scraper ---
print("Fetching data...")

# Set headers to look like a browser
headers = {"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64)"}

# Get the webpage
response = requests.get(URL, headers=headers)

if response.status_code == 200:
    # Parse the HTML
    soup = BeautifulSoup(response.text, "html.parser")

    # Find the first headline (Hacker News specific tag)
    first_headline_tag = soup.find("span", class_="titleline")
    
    # Extract just the text
    headline_text = first_headline_tag.text
    print(f"Found headline: {headline_text}")

    # --- Part 2: The Data Logger ---
    # Append the headline to a text file
    with open(FILE_NAME, "a") as file:
        file.write(headline_text + "\n")
    print(f"Saved to {FILE_NAME}")

    # --- Part 3: The Notifier ---
    # Prepare the email
    subject = "Daily Tech News"
    body = headline_text
    
    # Construct the message string (Subject + Double Newline + Body)
    message = f"Subject: {subject}\n\n{body}"

    try:
        # Connect to Gmail's server
        with smtplib.SMTP('smtp.gmail.com', 587) as server:
            server.starttls()  # Secure the connection
            server.login(USER_EMAIL, EMAIL_PASSWORD)
            server.sendmail(USER_EMAIL, RECIPIENT_EMAIL, message)
        
        print("Email notification sent successfully!")

    except Exception as e:
        print(f"Failed to send email: {e}")

else:
    print(f"Failed to retrieve webpage. Status code: {response.status_code}")