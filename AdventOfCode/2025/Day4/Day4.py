"""
------------------------------------------------------------------------
Challenge: Day 4 - Printing Department (Part 1)
------------------------------------------------------------------------
Author: Jac-Now

Context:
    We need to determine which paper rolls ('@') are accessible to forklifts.
    A paper roll is accessible if it is NOT crowded.

Mechanics:
    - The warehouse is a 2D grid of characters.
    - '@' represents a paper roll. '.' represents empty space.
    - A roll is accessible if it has FEWER than 4 neighbors (up/down/left/right/diagonal).

Goal:
    - Scan every cell in the grid.
    - For every '@', count its '@' neighbors.
    - If neighbors < 4, it counts towards the answer.
------------------------------------------------------------------------
"""
import os

def load_input(filename):
    """
    Reads the input file into a list of strings.
    Each string represents one ROW in the grid.
    """
    script_dir = os.path.dirname(os.path.abspath(__file__))
    file_path = os.path.join(script_dir, filename)
    
    if not os.path.exists(file_path):
        return []
        
    with open(file_path, 'r') as f:
        # .splitlines() removes the \n characters from the end of lines
        return f.read().splitlines()

def count_accessible_paper(grid):
    """
    Main logic to solve the puzzle.
    Args:
        grid (list of str): The 2D map of the warehouse.
    Returns:
        int: The total number of accessible paper rolls.
    """
    # 1. Determine Grid Dimensions
    # 'rows' is how many lines of text we have (Height)
    rows = len(grid)
    # 'cols' is how many characters are in the first line (Width)
    cols = len(grid[0])
    
    accessible_count = 0
    
    # 2. Define Relative Moves
    # These represent the 8 directions around a specific point (r, c).
    # Format: (change_in_row, change_in_col)
    moves = [
        (-1, -1), (-1, 0), (-1, 1), # Top-Left, Top, Top-Right
        (0, -1),           (0, 1),  # Left,      Right
        (1, -1),  (1, 0),  (1, 1)   # Bot-Left, Bot, Bot-Right
    ]

    # 3. Iterate through every cell in the grid
    # We use nested loops: Outer loop for rows, Inner loop for columns.
    for r in range(rows):
        for c in range(cols):
            
            # OPTIMIZATION:
            # If the current cell is empty ('.'), we don't need to check it.
            # We only care about paper rolls ('@').
            if grid[r][c] != '@':
                continue
                
            # 4. Count the Neighbors for this specific paper roll
            neighbor_paper_count = 0
            
            # Check all 8 directions defined in 'moves'
            for dr, dc in moves:
                # Calculate the neighbor's coordinate
                new_r = r + dr
                new_c = c + dc
                
                # SAFETY CHECK (CRITICAL):
                # We must ensure the neighbor coordinate is actually inside the grid.
                # If new_r is -1, we are looking off the top edge.
                # If new_r is equal to 'rows', we are looking off the bottom edge.
                if new_r < 0 or new_r >= rows or new_c < 0 or new_c >= cols:
                    continue # Skip this neighbor, it doesn't exist (it's void)
                
                # If the neighbor is valid, check if it contains paper
                if grid[new_r][new_c] == '@':
                    neighbor_paper_count += 1
            
            # 5. Apply the Rule
            # "fewer than 4 rolls of paper in the 8 adjacent positions"
            if neighbor_paper_count < 4:
                accessible_count += 1
                
    return accessible_count

"""
------------------------------------------------------------------------
Challenge: Day 4 - Printing Department (Part 2)
------------------------------------------------------------------------
Context:
    The problem shifts from a static check to a dynamic simulation.
    Once a paper roll is accessible, it is REMOVED from the warehouse.
    Removing a roll creates empty space, which might make OTHER rolls 
    accessible in the next "round".

Mechanics:
    - Cellular Automata / Simulation Loop.
    - We must identify ALL rolls that are accessible in the current configuration.
    - We remove them ALL AT ONCE (Batch Update).
    - We repeat this process until no more rolls can be removed.

Goal:
    - Count the total number of paper rolls removed throughout the entire simulation.
------------------------------------------------------------------------
"""

def count_accessible_paper_part2(raw_grid):
    """
    Simulates the repetitive removal of paper rolls.
    """
    # ----------------------------------------------------------------
    # SETUP PHASE
    # ----------------------------------------------------------------
    # Python strings (e.g., "@@..") are immutable, meaning we cannot change 
    # individual characters. We must convert the grid into a List of Lists 
    # to allow us to update the grid (grid[r][c] = '.') later.
    grid = [list(row) for row in raw_grid]
    
    accessible_count = 0
    
    # Define Relative Moves (Vector Arithmetic)
    # These represent the 8 directions around a specific point (r, c).
    # Format: (change_in_row, change_in_col)
    moves = [
        (-1, -1), (-1, 0), (-1, 1), # Top-Left, Top, Top-Right
        (0, -1),           (0, 1),  # Left,      Right
        (1, -1),  (1, 0),  (1, 1)   # Bot-Left, Bot, Bot-Right
    ]

    # ----------------------------------------------------------------
    # SIMULATION LOOP
    # ----------------------------------------------------------------
    # We use 'while True' because we don't know how many rounds it will take.
    # We will break out manually when no changes occur.
    while True:
        
        # 'changes' acts as a temporary buffer.
        # We cannot remove items immediately because that would change the 
        # neighbor counts for other cells in the *same* round.
        # This enforces the "Simultaneous Update" rule.
        changes = []
        
        rows = len(grid)
        cols = len(grid[0])

        # --- SCAN PHASE ---
        # Iterate through every cell to find candidates for removal
        for r in range(rows):
            for c in range(cols):
                
                # OPTIMIZATION:
                # Skip empty spots. We only care about existing paper rolls.
                if grid[r][c] != '@':
                    continue
                    
                # Count Neighbors
                neighbor_paper_count = 0
                
                # Check all 8 directions
                for dr, dc in moves:
                    new_r = r + dr
                    new_c = c + dc
                    
                    # SAFETY CHECK (Boundary Validation):
                    # Ensure we don't try to look outside the grid limits.
                    # 1. new_r must be >= 0 and < total rows
                    # 2. new_c must be >= 0 and < total cols
                    if new_r < 0 or new_r >= rows or new_c < 0 or new_c >= cols:
                        continue # It's off the map (void), so it's not paper.
                    
                    # If valid neighbor, check for paper
                    if grid[new_r][new_c] == '@':
                        neighbor_paper_count += 1
                
                # APPLY THE RULE:
                # "Fewer than 4 rolls of paper in the 8 adjacent positions"
                if neighbor_paper_count < 4:
                    accessible_count += 1
                    # Mark for removal, but don't remove yet!
                    changes.append((r, c))
        
        # --- UPDATE PHASE ---
        
        # STOP CONDITION:
        # If the 'changes' list is empty, it means the grid has stabilized.
        # No more paper can be reached. We are done.
        if changes == []:
            break
            
        # Process the Batch Updates
        for r, c in changes:
            # Change '@' to '.' (Empty Space)
            # This will affect the neighbor counts in the NEXT round.
            grid[r][c] = '.'
            
    # Return the total accumulated count after the simulation stops
    return accessible_count


# ==========================================
# Main Execution
# ==========================================
if __name__ == "__main__":
    
    # 1. Run Example Data
    # -------------------
    sample_data = [
        "..@@.@@@@.",
        "@@@.@.@.@@",
        "@@@@@.@.@@",
        "@.@@@@..@.",
        "@@.@@@@.@@",
        ".@@@@@@@.@",
        ".@.@.@.@@@",
        "@.@@@.@@@@",
        ".@@@@@@@@.",
        "@.@.@@@.@."
    ]
    
    print("--- Example Data ---")
    print(f"Result: {count_accessible_paper(sample_data)}")
    

    # 2. Run Real Data
    # ----------------
    real_data = load_input('day4-data.txt')
    if real_data:
        print("\n--- Real Data ---")
        print(f"Part 1 Answer: {count_accessible_paper(real_data)}")
    else:
        print("\nReal data file not found (day4-data.txt). Skipping.")

     # 3. Part 2 Execution
    # ---------------------
    print("\n--- Part 2 Example Data ---")
    print(f"Result: {count_accessible_paper_part2(sample_data)}")
    if real_data:
        print("\n--- Part 2 Real Data ---")
        print(f"Part 2 Answer: {count_accessible_paper_part2(real_data)}")


