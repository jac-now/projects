package main

import (
	"bufio"
	"fmt"
	"os"
)

// Point is a simple structure to hold Grid Coordinates.
// In Python, we used tuples (r, c). In Go, explicit structs are cleaner.
type Point struct {
	r, c int
}

/*
------------------------------------------------------------------------

	HELPER: File Loader

------------------------------------------------------------------------
*/
func loadInput(filename string) ([]string, error) {
	file, err := os.Open(filename)
	if err != nil {
		return nil, err
	}
	defer file.Close()

	var lines []string
	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		lines = append(lines, scanner.Text())
	}
	return lines, scanner.Err()
}

/*
------------------------------------------------------------------------

	PART 1: Static Grid Check

------------------------------------------------------------------------
*/
func solvePart1(grid []string) int {
	rows := len(grid)
	cols := len(grid[0])
	accessibleCount := 0

	// Define the 8 directions (neighbor offsets)
	// We use a slice of Points to store the offsets
	moves := []Point{
		{-1, -1}, {-1, 0}, {-1, 1}, // Top Row
		{0, -1}, {0, 1}, // Middle Row
		{1, -1}, {1, 0}, {1, 1}, // Bottom Row
	}

	// Loop through every Row and Column
	for r := 0; r < rows; r++ {
		for c := 0; c < cols; c++ {

			// GO CONCEPT: Accessing Characters
			// grid[r][c] gives us a 'byte' (ASCII value).
			// We verify if it is equal to the byte for '@'.
			if grid[r][c] != '@' {
				continue
			}

			neighborPaperCount := 0

			// Iterate through the 8 directions
			for _, move := range moves {
				newR := r + move.r
				newC := c + move.c

				// BOUNDARY CHECK
				// Go logic is identical to Python here.
				// Check if we are outside the valid index range.
				if newR < 0 || newR >= rows || newC < 0 || newC >= cols {
					continue
				}

				// Check neighbor content
				if grid[newR][newC] == '@' {
					neighborPaperCount++
				}
			}

			// Apply the Rule: Less than 4 neighbors
			if neighborPaperCount < 4 {
				accessibleCount++
			}
		}
	}

	return accessibleCount
}

/*
------------------------------------------------------------------------

	PART 2: Dynamic Simulation

------------------------------------------------------------------------
*/
func solvePart2(input []string) int {
	/*
	   GO CONCEPT: Mutable Grids
	   In Go, 'string' types are IMMUTABLE (read-only), just like Python.
	   To modify the grid (change '@' to '.'), we must convert it into
	   a "Slice of Slices of Runes" ([][]rune).

	   - A 'rune' is Go's name for a Unicode character.
	   - We allocate the outer slice, then loop to convert each string row.
	*/
	rows := len(input)
	cols := len(input[0])

	// Create the grid container
	grid := make([][]rune, rows)

	for i, rowStr := range input {
		// Convert string "@@.." to slice of runes ['@', '@', '.', '.']
		grid[i] = []rune(rowStr)
	}

	totalRemoved := 0

	// Define moves again (same as Part 1)
	moves := []Point{
		{-1, -1}, {-1, 0}, {-1, 1},
		{0, -1}, {0, 1},
		{1, -1}, {1, 0}, {1, 1},
	}

	// START SIMULATION LOOP
	// Go doesn't have 'while'. We use 'for' without conditions for infinite loops.
	for {
		// 'changes' acts as our buffer.
		// It holds the coordinates (Points) of items to remove this round.
		// We initialize it with capacity 0.
		var changes []Point

		// --- SCAN PHASE ---
		for r := 0; r < rows; r++ {
			for c := 0; c < cols; c++ {

				// Only check existing paper
				if grid[r][c] != '@' {
					continue
				}

				neighborCount := 0

				// Check 8 neighbors
				for _, move := range moves {
					newR := r + move.r
					newC := c + move.c

					// Bounds Check
					if newR < 0 || newR >= rows || newC < 0 || newC >= cols {
						continue
					}

					// Check content
					if grid[newR][newC] == '@' {
						neighborCount++
					}
				}

				// Check Rule
				if neighborCount < 4 {
					// Add this coordinate to our batch list
					// append() is how we add to lists in Go
					changes = append(changes, Point{r, c})
				}
			}
		}

		// --- UPDATE PHASE ---

		// Stop Condition: If changes slice is empty, we are done.
		if len(changes) == 0 {
			break
		}

		// Add to total
		totalRemoved += len(changes)

		// Apply the batch updates
		// We loop through our 'changes' slice
		for _, p := range changes {
			// p is a Point struct {r, c}
			// We can safely modify the grid now because it is [][]rune
			grid[p.r][p.c] = '.'
		}
	}

	return totalRemoved
}

/*
------------------------------------------------------------------------

	MAIN ENTRY POINT

------------------------------------------------------------------------
*/
func main() {
	// 1. SAMPLE DATA
	sampleData := []string{
		"..@@.@@@@.",
		"@@@.@.@.@@",
		"@@@@@.@.@@",
		"@.@@@@..@.",
		"@@.@@@@.@@",
		".@@@@@@@.@",
		".@.@.@.@@@",
		"@.@@@.@@@@",
		".@@@@@@@@.",
		"@.@.@@@.@.",
	}

	fmt.Println("--- SAMPLE DATA ---")
	fmt.Printf("Part 1: %d\n", solvePart1(sampleData))
	fmt.Printf("Part 2: %d\n", solvePart2(sampleData))
	fmt.Println()

	// 2. REAL DATA
	filename := "day4-data.txt"
	realData, err := loadInput(filename)

	if err != nil {
		fmt.Printf("Error reading %s: %v\n", filename, err)
	} else {
		fmt.Println("--- REAL DATA ---")
		fmt.Printf("Part 1: %d\n", solvePart1(realData))
		fmt.Printf("Part 2: %d\n", solvePart2(realData))
	}
}
