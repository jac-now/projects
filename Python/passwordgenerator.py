import random
import string

def generate_password(min_length=8):  # Added a default minimum length
    # Add more adjectives to expand word bank
    adjectives = [
        "Red", "Blue", "Green", "Yellow", "Orange", "Purple", "Black", "White", "Gray", 
              "Brown", "Large", "Small", "Tall", "Short", "Fast", "Slow", "Heavy", "Light", "Warm", "Cold",
              "Big", "Old", "New", "Long", "Wide", "High", "Deep", "Few", "Many", "Soft", "Hard", "Wet", 
              "Dry", "Rough", "Smooth", "Open", "Shut", "Hot", "Loud", "Dark", "Bright", "Full", "Empty",
              "Happy", "Sad", "Good", "Bad"
              ]
    #Add more nouns to expand word bank
    nouns = [
    "Cat", "Dog", "Elephant", "Shark", "Tiger", "Bear", "Zebra", "Mouse", "Kangaroo", "Donkey", 
    "Bicycle", "Car", "Train", "Bus", "Airplane", "Taxi", "Boat", "Scooter", "Motorcycle",
    "Skateboard", "Pen", "Cup", "Book", "Box", "Key", "Flag", "Shoe", "Ball", "Chair", "Phone", 
    "Light", "Watch", "Card", "Frog", "Duck", "Ant", "Pig", "Cow", "Bee", "Bug", "Shirt", "Sock", 
    "Coat", "Dress", "Pants", "Jacket", "Milk", "Egg", "Rice", "Soup", "Bread", "Cheese", "Apple", "Cake", "Bike"
]
    special_chars = "!@#$%^&*_+"  # Add more in future
    num_or_spec_char = string.digits + special_chars 
    #Password generation
    password = f"{random.choice(adjectives)}-{random.choice(nouns)}"  
    random_number = f"{random.randint(0, 9999):04d}"  
    special_char = random.choice(special_chars) 


    while len(password) < min_length -5:
        if random.random() < 0.8:  # 80% chance of a word pair - Change this value to change probability
            password = f"{password}-{random.choice(adjectives)}-{random.choice(nouns)}"
        else:  # 20% chance of a random character
            password = f"{password}-{random.choice(num_or_spec_char)}"

    password += f"{random_number}{special_char}" 
    return password


while True:
    try:
        desired_length = int(input("Enter the desired minimum password length (at least 8): "))
        if desired_length >= 8:
            password = generate_password(desired_length)
            print(password)
            break  # Exit the loop after getting a valid password
        else:
            print("Password length must be at least 8 characters.")
    except ValueError:
        print("Please enter a valid number.")
