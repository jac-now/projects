"""
------------------------------------------------------------------------
Challenge: Day 3 - Lobby (Part 1)
------------------------------------------------------------------------
Author: Jac-Now

Context:
    The elevators and escalators are out of power. We need to jump-start
    the escalator using specific batteries.
    
Mechanics:
    - Input is a list of strings (battery banks) e.g., "987654321".
    - From each bank, we must pick exactly TWO digits.
    - We cannot rearrange them; the order is fixed.
    - We want to form the largest possible 2-digit number (Joltage).

Goal:
    - Find the maximum 2-digit number possible for each line.
    - Sum these maximums together for the final answer.
------------------------------------------------------------------------
"""
import os

def load_input(filename):
    """
    Standard file loader. Returns list of lines.
    """
    script_dir = os.path.dirname(os.path.abspath(__file__))
    file_path = os.path.join(script_dir, filename)
    
    if not os.path.exists(file_path):
        return []
        
    with open(file_path, 'r') as f:
        return f.read().splitlines()

def get_max_joltage(bank):
    """
    Finds the largest possible 2-digit number in a string of digits,
    preserving the original order.
    """
    current_max = 0
    length = len(bank)

    # 1. Iterate through every digit to consider it as the "Tens" place
    # We stop 1 digit short of the end (length - 1) because the last digit
    # cannot be a "Tens" place.
    for i in range(length - 1):
        tens = int(bank[i])

        # -----------------------------------------------------------
        # OPTIMIZATION: The Early Exit
        # -----------------------------------------------------------
        # If we find a 9, we know we cannot possibly beat a 90-something.
        if tens == 9:
            best_one = int(max(bank[i+1:]))
            return (tens * 10) + best_one

        # -----------------------------------------------------------
        # STANDARD LOGIC
        # -----------------------------------------------------------
        # Look at the remaining string to the right
        remaining_digits = bank[i+1:]
        
        # Find the highest digit available in that remainder
        best_one = int(max(remaining_digits))
        
        # Calculate the potential score
        score = (tens * 10) + best_one

        # If this beats our current record, update the record
        if score > current_max:
            current_max = score

    return current_max

def solve_day3_part1(data):
    """
    Calculates the total output joltage by summing the max of each bank.
    """
    total_joltage = 0
    for line in data:
        total_joltage += get_max_joltage(line)
        
    return total_joltage

"""
------------------------------------------------------------------------
Challenge: Day 3 - Lobby (Part 2)
------------------------------------------------------------------------
Context:
    The escalator needs significantly more power to overcome static friction.
    We must now activate exactly TWELVE batteries per bank instead of two.

Mechanics:
    - Same input strings.
    - We must select exactly 12 digits, maintaining their original order.
    - The goal is to form the largest possible 12-digit number.

Strategy:
    - We cannot use nested loops (too slow).
    - We use a "Greedy" approach: Find the largest possible digit for the 
      1st spot, then the largest for the 2nd spot, etc.
    - Constraint: We must always leave enough digits remaining in the string
      to fill the rest of the 12 spots.
------------------------------------------------------------------------
"""

def get_max_joltage_v2(bank):
    """
    Finds the largest possible 12-digit number using a sliding window strategy.
    """
    needed = 12
    current_index = 0 
    length = len(bank)
    result = ""
    
    # We run this loop exactly 12 times to pick our 12 digits one by one
    for _ in range(12): 
        
        # 1. Calculate the Safety Margin
        # If we need 12 numbers total, and we are picking the 1st one,
        # we MUST leave 11 spots open at the end of the string.
        digits_to_reserve = needed - 1
        
        # 2. Define the "Search Window"
        # We can look from our current position up to the reservation point.
        search_end = length - digits_to_reserve
        
        # Slice the string to see valid candidates
        window = bank[current_index : search_end]
        
        # 
        
        # 3. Find the Winner
        # max() finds the largest character (e.g., '9').
        max_digit = max(window)
        
        # Append to our result
        result += max_digit
        
        # 4. Move the Start Point
        # We must advance our index to be AFTER the digit we just picked.
        # bank.index(val, start) finds the first occurrence starting from 'start'.
        current_index = bank.index(max_digit, current_index) + 1
        
        # We need one less digit now
        needed -= 1
        
    return int(result)

def solve_day3_part2(data):
    """
    Calculates the total output joltage for the 12-digit requirement.
    """
    total_joltage = 0
    for line in data:
        total_joltage += get_max_joltage_v2(line)
        
    return total_joltage

# ==========================================
# Main Execution
# ==========================================
if __name__ == "__main__":
    
    # 1. Run Example Data
    example_data = [
        "987654321111111", 
        "811111111111119", 
        "234234234234278", 
        "818181911112111"  
    ]
    
    print("--- Example Data ---")
    print(f"Part 1 Result: {solve_day3_part1(example_data)}")
    print(f"Part 2 Result: {solve_day3_part2(example_data)}")

    # 2. Run Real Data (if file exists)
    real_data = load_input('day3-data.txt')
    if real_data:
        print("\n--- Real Data ---")
        print(f"Part 1 Result: {solve_day3_part1(real_data)}")
        print(f"Part 2 Result: {solve_day3_part2(real_data)}")
    else:
        print("\nReal data file not found (day3-data.txt). Skipping.")