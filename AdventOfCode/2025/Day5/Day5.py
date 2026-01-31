"""
------------------------------------------------------------------------
Challenge: Day 5 - Cafeteria
------------------------------------------------------------------------
Author: Jac-Now

Context:
    The Elves have a messy database of ingredients. We need to determine
    which ingredients are fresh based on a list of valid ID ranges.

    The Input File format is split into two sections:
    1. A list of ranges (e.g., "3-5", "10-20").
    2. A list of specific Ingredient IDs (e.g., "1", "5", "32").
    They are separated by a double newline (blank line).
------------------------------------------------------------------------
"""
import os

def load_full_input(filename):
    """
    Reads the entire file as a single string.
    
    Why: The input file structure relies on a blank line (\n\n) to separate 
    the 'Ranges' section from the 'IDs' section. Reading it as one big block 
    makes splitting it trivial.
    """
    script_dir = os.path.dirname(os.path.abspath(__file__))
    file_path = os.path.join(script_dir, filename)
    
    if not os.path.exists(file_path):
        return ""
        
    with open(file_path, 'r') as f:
        return f.read()

"""
------------------------------------------------------------------------
PART 1: Checking Specific IDs
------------------------------------------------------------------------
Goal:
    Count how many of the provided 'Available IDs' fall into ANY of the 
    'Fresh Ranges'.

Mechanics:
    - We parse the ranges into Python `range` objects.
    - We loop through the list of specific IDs.
    - If an ID exists in a range, it counts as fresh.
------------------------------------------------------------------------
"""
def solve_day5_part1(raw_data):
    fresh_count = 0
    
    # 1. SPLIT DATA
    # The strip() removes leading/trailing whitespace.
    # The split('\n\n') breaks the file into [Range Block, ID Block].
    parts = raw_data.strip().split('\n\n')
    
    # Safety Check: Ensure the file actually had two sections
    if len(parts) < 2:
        return 0

    range_lines = parts[0].splitlines()
    id_lines = parts[1].splitlines()
    
    # 2. PARSE RANGES
    # We store the ranges in a list so we can iterate over them later.
    fresh_ranges = []
    
    for line in range_lines:
        if not line.strip(): continue # Skip empty lines

        # Input format is "Start-End" (e.g., "10-14")
        range_parts = line.split('-')
        start = int(range_parts[0])
        end = int(range_parts[1])

        # IMPORTANT: Python range(a, b) includes 'a' but stops BEFORE 'b'.
        # The challenge says ranges are inclusive.
        # So "10-14" needs to become range(10, 15). We add +1.
        r = range(start, end + 1)
        fresh_ranges.append(r)

    # 3. CHECK IDS
    for line in id_lines:
        if not line.strip(): continue # Skip empty lines
        
        ingredient_id = int(line)
        
        # Check this ID against every known fresh range
        for r in fresh_ranges:
            # The 'in' operator is mathematically optimized for range objects.
            # It doesn't generate the whole list, it just does math.
            if ingredient_id in r:
                fresh_count += 1
                break # We found a match! No need to check other ranges for this ID.
                
    return fresh_count


"""
------------------------------------------------------------------------
PART 2: Calculating Total Unique Fresh IDs
------------------------------------------------------------------------
Goal:
    Ignore the 'Available IDs' list. 
    Instead, count how many TOTAL unique integers exist within the 
    'Fresh Ranges' combined.

The Twist (The Memory Trap):
    - The real input data contains ranges spanning Billions/Trillions.
    - We cannot use a List or Set to store individual numbers, or we will
      crash the computer's RAM (Memory Error).
    
Solution (Interval Merging):
    - We treat the ranges as mathematical intervals.
    - We sort them and merge overlapping intervals.
    - Example: Merging "1-10" and "5-15" results in "1-15".
    - Then we just calculate the size: (End - Start) + 1.
------------------------------------------------------------------------
"""

def solve_day5_part2(raw_data):
    # ----------------------------------------------------------------
    # STEP 1: PREPARE THE DATA
    # ----------------------------------------------------------------
    # We split the file into two blocks, but we only need the top block (Ranges).
    parts = raw_data.strip().split('\n\n')
    range_lines = parts[0].splitlines()
    
    # We will store the ranges as simple tuples: (Start, End).
    # We do NOT expand them into full lists of numbers because that would 
    # use too much RAM (Terabytes!) given the trillions of numbers involved.
    ranges = []

    for line in range_lines:
        if not line.strip(): 
            continue

        # Parse "100-200" into numbers start=100, end=200
        parts = line.split('-')
        start = int(parts[0])
        end = int(parts[1])

        # Just save the endpoints. 
        # Analogy: Instead of writing down every page number in a chapter,
        # we just write down "Pages 100 to 200".
        ranges.append((start, end))

    # ----------------------------------------------------------------
    # STEP 2: SORTING (CRITICAL)
    # ----------------------------------------------------------------
    # We sort the ranges by their starting number.
    # Why? Imagine laying strips of tape on the floor. It is much easier 
    # to measure the total length if you lay them down from Left to Right.
    # Python sorts list of tuples by the first item automatically.
    ranges.sort()
    
    if not ranges:
        return 0

    # ----------------------------------------------------------------
    # STEP 3: THE MERGE LOGIC
    # ----------------------------------------------------------------
    total_fresh_count = 0
    
    # Pick up the first "strip of tape" (Range 0) to start our measurement.
    current_start, current_end = ranges[0]
    
    # Loop through every other strip of tape, starting from the second one
    for i in range(1, len(ranges)):
        # Grab the next strip
        next_start, next_end = ranges[i]
        
        # CHECK: Does this new strip overlap or touch our current strip?
        # We check: Does the new one start *before* (or exactly when) the current one ends?
        # The '+ 1' handles touching: e.g., if one ends at 10 and next starts at 11, they connect.
        if next_start <= current_end + 1:
            
            # YES, IT CONNECTS!
            # Imagine sticking this new piece of tape onto the current one.
            # We don't change the start point, but we might need to extend the end point.
            # If the new strip is longer, our 'current_end' gets pushed out further.
            current_end = max(current_end, next_end)
            
        else:
            # NO, THERE IS A GAP!
            # The previous strip of tape has ended. There is empty space before the next one.
            
            # 1. Measure the strip we just finished working on.
            # Math: (End - Start) + 1. 
            # (If a strip covers 5-5, that is 1 unit long, so 5-5+1 = 1).
            size_of_strip = (current_end - current_start + 1)
            total_fresh_count += size_of_strip
            
            # 2. Pick up the NEW strip and start measuring again.
            current_start = next_start
            current_end = next_end
            
    # ----------------------------------------------------------------
    # STEP 4: FINALIZE
    # ----------------------------------------------------------------
    # The loop finishes when we run out of strips, but we are still holding 
    # the very last strip in our variables (current_start/current_end).
    # We haven't added its length to the total yet. Do that now.
    total_fresh_count += (current_end - current_start + 1)

    return total_fresh_count

# ==========================================
# Main Execution
# ==========================================
if __name__ == "__main__":
    
    # Example Data
    # Note: We use a raw string with \n to mimic the file format
    sample_data = """3-5
10-14
16-20
12-18

1
5
8
11
17
32"""

    print("\n--- Part 1 ---")
    print(f"Example Data Result: {solve_day5_part1(sample_data)}") # Expected: 3
    
    # Real Data
    # Ensure you create day5-data.txt!
    real_data = load_full_input('day5-data.txt')
    if real_data:
        print(f"Real Data Result: {solve_day5_part1(real_data)}")
    

    print("\n--- Part 2 ---")
    print(f"Example Data Result: {solve_day5_part2(sample_data)}") # Expected: 14
    
    # Real Data
    # Ensure you create day5-data.txt!
    real_data = load_full_input('day5-data.txt')
    if real_data:
        print(f"Real Data Result: {solve_day5_part2(real_data)}")