from flask import Flask, render_template, request, redirect, url_for
from locations import Locations
from forms import AddLocationForm

# Initialize the Flask application
app = Flask(__name__)
# Set the secret key for session management
app.config['SECRET_KEY'] = 'SECRET_PROJECT'

# Initialize the Locations object to manage location data
visit = Locations()
# Define categories for locations
categories = {"recommended": "Recommended", "tovisit": "Places To Go", "visited": "Visited!!!"}

# Define constants for actions
UP_ACTION = "\u2197"  # Unicode for an upward arrow
DEL_ACTION = "X"  # Symbol for delete action

@app.route("/<category>", methods=["GET", "POST"])
def locations(category):
    # Get the list of locations for the given category
    locations = visit.get_list_by_category(category)
    
    # Check if the request method is POST to handle form submissions
    if request.method == "POST":
        # Extract the form data (name and action)
        [(name, action)] = request.form.items()

        # Perform the appropriate action based on the form data
        if action == UP_ACTION:
            visit.moveup(name)  # Move the location up in the list
        elif action == DEL_ACTION:
            visit.delete(name)  # Delete the location from the list
    
    # Render the locations template with the necessary variables
    return render_template("locations.html", category=category, categories=categories, locations=locations, add_location=AddLocationForm())

@app.route("/add_location", methods=["POST"])
def add_location():
    # Create an instance of the AddLocationForm
    add_form = AddLocationForm(csrf_enabled=False)
    
    # Validate the form data and add the new location if valid
    if add_form.validate_on_submit():
        name = add_form.name.data
        description = add_form.description.data
        category = add_form.category.data
        visit.add(name, description, category)
    
    # Redirect to the locations route for the given category
    return redirect(url_for("locations", category=category, _external=True, _scheme="https"))

@app.route("/")
def index():
    # Redirect to the locations route with the default category "recommended"
    return redirect(url_for("locations", category="recommended", _external=True, _scheme="https"))