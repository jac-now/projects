import random
import string

def generate_password(min_length=8):  # Added a default minimum length
    # Add more adjectives to expand word bank
    adjectives = ["Red", "Blue", "Green", "Yellow", "Orange", "Purple", "Black", "White", "Gray", 
              "Brown", "Large", "Small", "Tall", "Short", "Fast", "Slow", "Heavy", "Light", "Warm", "Cold",
              "Big", "Old", "New", "Long", "Wide", "High", "Deep", "Few", "Many", "Soft", "Hard", "Wet", 
              "Dry", "Rough", "Smooth", "Open", "Shut", "Hot", "Loud", "Dark", "Bright", "Full", "Empty",
              "Happy", "Sad", "Good", "Bad"]
    #Add more nouns to expand word bank
    nouns = [
    "cat", "dog", "elephant", "shark", "tiger", "bear", "zebra", "mouse", "kangaroo", "donkey", 
    "bicycle", "car", "train", "bus", "airplane", "taxi", "boat", "scooter", "motorcycle",
    "skateboard", "pen", "cup", "book", "box", "key", "flag", "shoe", "ball", "chair", "phone", 
    "light", "watch", "card", "frog", "duck", "ant", "pig", "cow", "bee", "bug", "shirt", "sock", 
    "coat", "dress", "pants", "jacket", "milk", "egg", "rice", "soup", "bread", "cheese", "apple", "cake", "bike"
]
    special_chars = "!@#$%^&*_+"  # Adjust as needed
    num_or_spec_char = string.digits + special_chars  # All possible characters
    #Password generation
    password = f"{random.choice(adjectives)}{random.choice(nouns)}"  
    random_number = f"{random.randint(0, 9999):04d}"  
    special_char = random.choice(special_chars) 

    # Modified filling loop
    while len(password) < min_length:
        if random.random() < 0.5:  # 50% chance of a word pair
            password = f"{random.choice(adjectives)}{random.choice(nouns)}-{password}"
        else:  # 50% chance of a random character
            password = f"{random.choice(num_or_spec_char)}{password}"

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