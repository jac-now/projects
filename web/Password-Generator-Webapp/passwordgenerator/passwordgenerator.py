import random
import string

def generate_password(min_length=8):
    # Word lists
    adjectives = [
        "Red", "Blue", "Green", "Yellow", "Orange", "Purple", "Black", "White", "Gray",
        "Brown", "Large", "Small", "Tall", "Short", "Fast", "Slow", "Heavy", "Light", "Warm", "Cold",
        "Big", "Old", "New", "Long", "Wide", "High", "Deep", "Few", "Many", "Soft", "Hard", "Wet",
        "Dry", "Rough", "Smooth", "Open", "Shut", "Hot", "Loud", "Dark", "Bright", "Full", "Empty",
        "Happy", "Sad", "Good", "Bad"
    ]
    nouns = [
        "Cat", "Dog", "Elephant", "Shark", "Tiger", "Bear", "Zebra", "Mouse", "Kangaroo", "Donkey",
        "Bicycle", "Car", "Train", "Bus", "Airplane", "Taxi", "Boat", "Scooter", "Motorcycle",
        "Skateboard", "Pen", "Cup", "Book", "Box", "Key", "Flag", "Shoe", "Ball", "Chair", "Phone",
        "Light", "Watch", "Card", "Frog", "Duck", "Ant", "Pig", "Cow", "Bee", "Bug", "Shirt", "Sock",
        "Coat", "Dress", "Pants", "Jacket", "Milk", "Egg", "Rice", "Soup", "Bread", "Cheese", "Apple", "Cake", "Bike"
    ]

    # Special characters and digits
    special_chars = "!@#$%^&*_+"
    num_or_spec_char = string.digits + special_chars

    # Password generation
    password = f"{random.choice(adjectives)}-{random.choice(nouns)}"
    random_number = f"{random.randint(0, 99):02d}"  # Four-digit random number
    special_char = random.choice(special_chars)

    # Fill to meet minimum length
    while len(password) < min_length - 3:
        if random.random() < 0.3:  #30% chance for adjective-noun pair to be added 70% for digit or spec char
            password = f"{password}-{random.choice(adjectives)}-{random.choice(nouns)}"
        else:
            password = f"{password}{random.choice(num_or_spec_char)}"

    # Add the random number and special character at the end
    password += f"{random_number}{special_char}"

    return password
