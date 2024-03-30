import random
import string

def generate_password():
    # List of words to choose from
    wordsA = ["Red", "Blue", "Green", "Yellow", "Orange", "Purple", "Black", "White", "Gray", 
        "Brown", "Large", "Small", "Tall", "Short", "Fast", "Slow", "Heavy", "Light", "Warm", "Cold"]
    wordsB = [
        "cat", "dog", "elephant", "shark", "tiger", "bear", "zebra", "mouse", "kangaroo", "donkey"
        "bicycle", "car", "train", "bus", "airplane", "taxi", "boat", "scooter", "motorcycle",
        "skateboard",]

    # Select a random word from each list
    word1 = random.choice(wordsA)
    word2 = random.choice(wordsB)

    # Generate a random number between 0 and 99
    random_number = random.randint(0, 99)

    # Combine the words with a '-' delimiter and append the random number
    password = f"{word1}-{word2}{random_number}"

    return password

# Generate and print a random password
print(generate_password())