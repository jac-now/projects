import csv

# Class to manage a collection of locations
class Locations:
    def __init__(self):
        self.locations = []  # Initialize an empty list to store locations
        self.load_data()  # Load data from CSV file upon initialization

    # Method to add a new location to the list
    def add(self, name, description, category):
        if name is not None and description is not None and category is not None:
            location = Location(name, description, category)  # Create a new Location object
            self.locations.append(location)  # Add the new location to the list

    # Method to get the index of a location by its name
    def get_index_by_name(self, name):
        for i, location in enumerate(self.locations):
            if location.name == name:
                return i  # Return the index if the name matches

    # Method to get a list of locations by category
    def get_list_by_category(self, category):
        locs = []
        for i, location in enumerate(self.locations):
            if location.category == category:
                locs.append(location)  # Add location to the list if the category matches
        return locs  # Return the list of locations

    # Method to delete a location by its name
    def delete(self, name):
        i = self.get_index_by_name(name)  # Get the index of the location
        self.locations.pop(i)  # Remove the location from the list

    # Method to move a location up in its category
    def moveup(self, name):
        i = self.get_index_by_name(name)  # Get the index of the location
        if self.locations[i].category == "recommended":
            self.locations[i].category = "tovisit"  # Change category from recommended to tovisit
        elif self.locations[i].category == "tovisit":
            self.locations[i].category = "visited"  # Change category from tovisit to visited

    # Method to load data from a CSV file
    def load_data(self):
        with open("data.csv", "r") as csvfile:
            locations = csv.reader(csvfile)
            for row in locations:
                self.add(row[0], row[1], row[2])  # Add each row from the CSV file as a location

    # Method to represent the object as a string
    def __repr__(self):
        for location in self.locations:
            print(f'{location.name} - {location.description} - {location.category}')  # Print each location


# Class to represent a single location
class Location:
    def __init__(self, name, description, category):
        self.name = name  # Name of the location
        self.description = description  # Description of the location
        self.category = category  # Category of the location