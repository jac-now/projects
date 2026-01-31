package main
// ^ In Go, every file belongs to a 'package'. 
// 'package main' tells the compiler that this file should compile into 
// an executable program, not a shared library.

import (
	"bufio"   // "Buffered I/O" - Efficiently reading text
	"fmt"     // "Format" - Printing to the console (like print())
	"os"      // "Operating System" - Opening files, interacting with the OS
	"strconv" // "String Conversion" - Turning strings into numbers
)

/*
------------------------------------------------------------------------
   HELPER: Mathematical Modulo
------------------------------------------------------------------------
   Problem: In Go (and C/Java), -1 % 100 = -1.
   Goal: We want Python behavior, where -1 % 100 = 99.
   Solution: Add the modulus (m) to the result and modulo again.
*/
func positiveMod(n, m int) int {
	return ((n % m) + m) % m
}

/*
------------------------------------------------------------------------
   PART 1: The Teleport Method
------------------------------------------------------------------------
   calculates destination directly using math.
   Input: 'data' is a slice (list) of strings.
   Output: Returns an integer (int).
*/
func solveSafePart1(data []string) int {
	// ":=" is the "Short Variable Declaration".
	// Go infers that currentPos is an 'int' based on the value 50.
	currentPos := 50
	zeroCount := 0

	// 'range' iterates over a slice (list).
	// It returns two values: the Index (0,1,2...) and the Value ("L68"...).
	// We use '_' (the blank identifier) to ignore the Index because we don't need it.
	for _, step := range data {
		
		// PARSING
		// step[0] gets the first byte (ASCII code), not a string.
		// We wrap it in string() to convert it back to text like "L" or "R".
		direction := string(step[0])
		
		// step[1:] slices the string from index 1 to the end (grabbing the number).
		// Atoi (ASCII to Integer) returns two values: the number AND an error.
		// We use '_' to ignore the error here (assuming input is always valid).
		amount, _ := strconv.Atoi(step[1:])

		// LOGIC
		if direction == "R" {
			currentPos = (currentPos + amount) % 100
		} else if direction == "L" {
			// We subtract amount. We use our helper to handle negative wrap-around.
			currentPos = positiveMod(currentPos - amount, 100)
		}

		// CHECK GOAL
		if currentPos == 0 {
			zeroCount++ // "++" increments the number by 1
		}
	}
	return zeroCount
}

/*
------------------------------------------------------------------------
   PART 2: The Simulation Method
------------------------------------------------------------------------
   Simulates every single tick of the dial.
*/
func solveSafePart2(data []string) int {
	currentPos := 50
	zeroCount := 0

	for _, step := range data {
		direction := string(step[0])
		amount, _ := strconv.Atoi(step[1:])

		// INNER LOOP
		// The standard C-style loop:
		// 1. Init: i := 0
		// 2. Condition: Run while i < amount
		// 3. Post: i++ (add 1 to i after every loop)
		for i := 0; i < amount; i++ {
			if direction == "R" {
				currentPos = (currentPos + 1) % 100
			} else if direction == "L" {
				currentPos = positiveMod(currentPos - 1, 100)
			}

			// We check for zero inside the movement loop to catch
			// every time the dial passes 0.
			if currentPos == 0 {
				zeroCount++
			}
		}
	}
	return zeroCount
}

/*
------------------------------------------------------------------------
   FILE LOADER
------------------------------------------------------------------------
   Reads a file and returns a slice of strings ([]string) OR an error.
*/
func loadInput(filename string) ([]string, error) {
	// attempt to open the file
	file, err := os.Open(filename)
	
	// Error handling in Go is explicit. If err is NOT nil, something broke.
	if err != nil {
		return nil, err
	}
	
	// 'defer' is a special keyword. It says:
	// "Execute this line (closing the file) only when the function finishes."
	// This ensures we don't leave files open, even if we crash later.
	defer file.Close()

	var lines []string // Declare an empty slice of strings
	
	// Create a scanner to read the file line-by-line
	scanner := bufio.NewScanner(file)
	
	// .Scan() returns true as long as there is another line to read
	for scanner.Scan() {
		// .Text() gets the current line string.
		// append() adds it to our slice.
		lines = append(lines, scanner.Text())
	}
	
	// Return the list of lines, and any error that might have happened during scanning
	return lines, scanner.Err()
}

/*
------------------------------------------------------------------------
   MAIN ENTRY POINT
------------------------------------------------------------------------
   When you run "go run main.go", this function executes first.
*/
func main() {
	// 1. Load Data
	// Go functions can return multiple values. Here: instructions AND error.
	instructions, err := loadInput("day1-data.txt")
	
	// If there was an error reading the file, print it and stop the program.
	if err != nil {
		fmt.Println("Error reading file:", err)
		return
	}

	// 2. Run Part 1
	part1 := solveSafePart1(instructions)
	// %d is a placeholder for a digit/integer
	fmt.Printf("Part 1 Password: %d\n", part1)

	// 3. Run Part 2
	part2 := solveSafePart2(instructions)
	fmt.Printf("Part 2 Password: %d\n", part2)
}