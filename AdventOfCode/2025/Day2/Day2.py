"""
------------------------------------------------------------------------
Challenge: Day 2 - Gift Shop (Part 1)
------------------------------------------------------------------------
Author: Jac-now
Context:
    The gift shop database has been corrupted with "invalid" product IDs.
    We are given a list of ID ranges (e.g., "11-22, 95-115").

Definition of Invalid ID (Part 1):
    - The ID is formed by a sequence of digits repeated exactly TWICE.
    - Examples: 
      - 55 (5 repeated twice) -> VALID
      - 6464 (64 repeated twice) -> VALID
      - 12345 (Odd length) -> IGNORE
      - 1213 (12 != 13) -> IGNORE

Goal:
    - Iterate through every number in the provided ranges.
    - Sum up all the "Invalid IDs".
------------------------------------------------------------------------
"""

def check_pattern_part1(num):
    """
    Checks if a number consists of a sequence repeated exactly twice.
    Logic: Split the string in half. Left must equal Right.
    """
    # 1. Convert to string to perform slicing
    s = str(num)
    length = len(s)

    # 2. Optimization: Odd length numbers cannot be split into two equal halves.
    if length % 2 != 0:
        return False

    # 3. Calculate the exact middle point
    mid = length // 2

    # 4. Slice and Compare
    first_half = s[:mid]
    second_half = s[mid:]
    
    if first_half == second_half:
        return True
    else:
        return False

def process_product_ranges(raw_input):
    """
    Parses the input string and calculates the sum of matching IDs for Part 1.
    """
    total_invalid_sum = 0
    
    # 1. Split the massive input string by comma to get individual ranges
    # Input format: "10-20,30-40,..."
    ranges = raw_input.strip().split(',')
    
    for r in ranges:
        # r is a string like "11-22"
        
        # Parse the Start and End of the range
        parts = r.split('-')
        start = int(parts[0])
        end = int(parts[1])
        
        # Iterate through the range
        # Note: range(start, end + 1) ensures we include the 'end' number
        for num in range(start, end + 1):
            if check_pattern_part1(num):
                total_invalid_sum += num
        
    return total_invalid_sum


"""
------------------------------------------------------------------------
Challenge: Day 2 - Gift Shop (Part 2)
------------------------------------------------------------------------
Context:
    The definition of an "Invalid ID" was stricter than we thought.

Definition of Invalid ID (Part 2):
    - The ID is formed by a sequence of digits repeated AT LEAST twice.
    - This includes the Part 1 matches (1212) but also new ones.
    - Examples:
      - 111 (1 repeated 3 times) -> VALID
      - 123123123 (123 repeated 3 times) -> VALID

Goal:
    - Re-scan the ranges using the generic repetition logic.
    - Sum up the new set of Invalid IDs.
------------------------------------------------------------------------
"""

def check_pattern_part2(num):
    """
    Checks if a number consists of a sequence repeated 2 or more times.
    Logic: Iterate through possible chunk sizes to see if they reconstruct the number.
    """
    s = str(num)
    length = len(s)

    # We test chunk sizes 'i' from 1 up to half the string length.
    # range(1, length // 2 + 1):
    #   - Start at 1: To catch single digit repeats (e.g., "111")
    #   - End at length // 2: A pattern cannot be larger than half the string 
    #     if it needs to repeat at least twice.
    for i in range(1, length // 2 + 1):
        
        # Optimization: If the total length isn't divisible by the chunk size,
        # that chunk size cannot possibly work. Skip it.
        if length % i != 0:
            continue
        
        # Define the pattern candidate (the first 'i' characters)
        pattern = s[:i]
        
        # Calculate how many times this pattern would need to repeat to fill the string
        multiplier = length // i
        
        # Reconstruct a string using the candidate pattern
        # If pattern is "12" and multiplier is 3, we create "121212"
        if pattern * multiplier == s:
            return True # Match found!
            
    # If we finish the loop without finding any matching pattern
    return False

def process_product_ranges_part2(raw_input):
    """
    Parses the input string and calculates the sum of matching IDs for Part 2.
    """
    total_invalid_sum = 0
    ranges = raw_input.strip().split(',')
    
    for r in ranges:
        parts = r.split('-')
        start = int(parts[0])
        end = int(parts[1])
        
        for num in range(start, end + 1):
            if check_pattern_part2(num):
                total_invalid_sum += num
        
    return total_invalid_sum


# ==========================================
# Main Execution
# ==========================================

# Sample input string (just the example data for now)
data_string1 = "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124"

# Actual sample data from challenge
data_string2 = "853-1994,1919078809-1919280414,1212082623-1212155811,2389-4173,863031-957102,9393261874-9393318257,541406-571080,1207634-1357714,36706-61095,6969667126-6969740758,761827-786237,5516637-5602471,211490-235924,282259781-282327082,587606-694322,960371-1022108,246136-353607,3-20,99-182,166156087-166181497,422-815,82805006-82876926,14165-30447,4775-7265,83298136-83428425,2439997-2463364,44-89,435793-511395,3291059-3440895,77768624-77786844,186-295,62668-105646,7490-11616,23-41,22951285-23017127"

if __name__ == "__main__":
    print("--- Calculating Part 1 ---")
    result1 = process_product_ranges(data_string2)
    print(f"Part 1 Sum: {result1}")

    print("\n--- Calculating Part 2 ---")
    result2 = process_product_ranges_part2(data_string2)
    print(f"Part 2 Sum: {result2}")