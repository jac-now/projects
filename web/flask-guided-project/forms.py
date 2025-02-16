from flask_wtf import FlaskForm  # Import FlaskForm from flask_wtf to create forms
from wtforms import StringField, SubmitField, TextAreaField, RadioField  # Import necessary fields from wtforms
from wtforms.validators import DataRequired  # Import DataRequired validator to ensure fields are not empty

class FieldsRequiredForm(FlaskForm):
    """Require radio fields to have content. This works around the bug that WTForms radio fields don't honor the `DataRequired` or `InputRequired` validators."""
    class Meta:
        def render_field(self, field, render_kw):
            # Check if the field type is "_Option" (used for radio fields)
            if field.type == "_Option":
                # Set the 'required' attribute to True to ensure the field is required
                render_kw.setdefault("required", True)
            # Call the parent class's render_field method
            return super().render_field(field, render_kw)

# Define categories for the radio field with tuples containing the value and label
categories = [("recommended","Recommended"), ("tovisit", "Places To Go"), ("visited", "Visited!!!")]

# Create the AddLocationForm class inheriting from FieldsRequiredForm
class AddLocationForm(FieldsRequiredForm):
    # Define a StringField for the location name with a DataRequired validator
    name = StringField("LocationName", validators=[DataRequired()])
    # Define a TextAreaField for the location description with a DataRequired validator
    description = TextAreaField("Location Description", validators=[DataRequired()])
    # Define a RadioField for the category with predefined choices
    category = RadioField("Category", choices=categories)
    # Define a SubmitField for the form submission
    submit = SubmitField("Add Location")