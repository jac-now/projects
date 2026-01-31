"""
------------------------------------------------------------------------
Challenge: Day 1 - Secret Entrance
------------------------------------------------------------------------
Author: Jac-now

Context:
    The Elves are locked out. The safe dial is a decoy.
    We need to decode the rotation instructions to find the password.

Mechanics:
    - Dial: 0 to 99 (Circular).
    - Start: Position 50.
    - Wrap-around: Right of 99 is 0; Left of 0 is 99.
------------------------------------------------------------------------
"""
import os

def load_input(filename):
    """
    Reads a text file relative to the script's location.
    Returns a list of strings (one per line).
    """
    script_dir = os.path.dirname(os.path.abspath(__file__))
    file_path = os.path.join(script_dir, filename)
    
    # Check if file exists to avoid crashing if you forget to add it
    if not os.path.exists(file_path):
        print(f"Warning: {filename} not found.")
        return []

    with open(file_path, 'r') as f:
        return f.read().splitlines()

def solve_part1(data):
    """
    Calculates the password based on where the dial LANDS.
    
    Goal: Count how many times the dial rests on 0 at the END of a rotation.
    """
    # 1. Initialize State
    current_pos = 50 
    zero_count = 0 

    for step in data:
        # Parsing: "R68" -> direction "R", amount 68
        direction = step[0]
        amount = int(step[1:])

        # 2. Update Position (The Teleport Method)
        # We use modulo 100 (% 100) to handle the circular wrapping.
        # Python handles negative modulo correctly (-1 % 100 = 99),
        # so we don't need extra 'if' checks for the boundaries.
        if direction == 'R':
            current_pos = (current_pos + amount) % 100
        elif direction == 'L':
            current_pos = (current_pos - amount) % 100

        # 3. Check Goal (Only at the end of the move)
        if current_pos == 0:
            zero_count += 1

    return zero_count

def solve_part2(data):
    """
    Calculates the password based on the JOURNEY.
    
    Goal: Count how many times the dial touches 0 DURING the rotation.
    """
    # 1. Initialize State
    current_pos = 50
    zero_count = 0

    for step in data:
        direction = step[0]
        amount = int(step[1:])

        # 2. Update Position (The Simulation Method)
        # We cannot just add the total 'amount' because we need to check
        # the dial status at every single 'click'.
        for _ in range(amount):
            
            # Move 1 step
            if direction == 'R':
                current_pos = (current_pos + 1) % 100
            elif direction == 'L':
                current_pos = (current_pos - 1) % 100

            # Check Goal (Inside the loop to catch fly-by zeros)
            if current_pos == 0:
                zero_count += 1

    return zero_count

# ==========================================
# Main Execution
# ==========================================
if __name__ == "__main__":
    
    # --- CONFIGURATION ---
    # Set this to True to test with sample data, False to use your file
    USE_SAMPLE_DATA = False 
    INPUT_FILENAME = 'day1-data.txt'

    # --- DATA LOADING ---
    sample_instructions = [
        "L68", "L30", "R48", "L5", "R60", 
        "L55", "L1", "L99", "R14", "L82"
    ]

    if USE_SAMPLE_DATA:
        print("--- RUNNING WITH SAMPLE DATA ---")
        instructions = sample_instructions
    else:
        print(f"--- RUNNING WITH FILE: {INPUT_FILENAME} ---")
        instructions = load_input(INPUT_FILENAME)

    # --- PART 1 ---
    if instructions:
        p1_result = solve_part1(instructions)
        print(f"Part 1 Password: {p1_result}")

        # --- PART 2 ---
        p2_result = solve_part2(instructions)
        print(f"Part 2 Password: {p2_result}")
    else:
        print("No data loaded. Check your file path or variable settings.")