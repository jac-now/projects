# Flask Guided Project

This project is a guided tutorial for building a web application using the Flask framework. It demonstrates how to create a simple to-do list style application for tracking places to visit.

## Table of Contents

- [Introduction](#introduction)
- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)

## Introduction

This project demonstrates how to create a simple web application using Flask. It covers the basics of setting up a Flask project, creating routes, rendering templates, and using Flask-WTF for forms.

## Features

- **Add and Manage Locations**: Users can add new locations with a name, description, and category.
- **Categorize Locations**: Locations are organized into three categories: "Recommended," "Places To Go," and "Visited!!!"
- **Move Locations**: Users can move locations between categories.
- **Delete Locations**: Users can delete locations from the list.
- **Data Persistence**: Location data is stored in a CSV file (`data.csv`).

## Installation

1. Clone the repository:
    ```bash
    git clone https://github.com/jacnow/projects/web/flask-guided-project.git
    ```
2. Navigate to the project directory:
    ```bash
    cd flask-guided-project
    ```
3. Create a virtual environment:
    ```bash
    python3 -m venv venv
    ```
4. Activate the virtual environment:
    - On Windows:
        ```bash
        venv\Scripts\activate
        ```
    - On Linux/Mac:
        ```bash
        source venv/bin/activate
        ```
5. Install the dependencies:
    ```bash
    pip install -r requirements.txt
    ```

## Usage

1. Run the Flask application:
    ```bash
    flask run
    ```
2. Open your web browser and go to `http://127.0.0.1:5000`.