package main

import (
	"bufio" // "Buffered I/O" - For efficient line-by-line reading
	"fmt"
	"os"      // For opening files
	"strconv" // For string->int conversion
	"strings" // For building strings
)

/*
------------------------------------------------------------------------

	HELPER: Find Max Digit in a Slice

------------------------------------------------------------------------
*/
func findMaxDigitInSlice(snippet string) (byte, int) {
	var maxChar byte = '0'
	maxIdx := 0

	for i := 0; i < len(snippet); i++ {
		char := snippet[i]
		if char > maxChar {
			maxChar = char
			maxIdx = i
		}
	}
	return maxChar, maxIdx
}

/*
------------------------------------------------------------------------

	PART 1: The "Tens" Optimization

------------------------------------------------------------------------
*/
func solvePart1(bank string) int64 {
	length := len(bank)
	// Safety Check
	if length < 2 {
		return 0
	}

	var currentMax int64 = 0

	for i := 0; i < length-1; i++ {
		tens := int64(bank[i] - '0')

		remaining := bank[i+1:]
		maxChar, _ := findMaxDigitInSlice(remaining)
		ones := int64(maxChar - '0')

		score := (tens * 10) + ones

		if tens == 9 {
			return score
		}

		if score > currentMax {
			currentMax = score
		}
	}
	return currentMax
}

/*
------------------------------------------------------------------------

	PART 2: The Greedy Sliding Window

------------------------------------------------------------------------
*/
func solvePart2(bank string) int64 {
	length := len(bank)
	// Safety Check
	if length < 12 {
		return 0
	}

	needed := 12
	currentIndex := 0
	var resultBuilder strings.Builder

	for k := 0; k < 12; k++ {
		digitsToReserve := needed - 1
		searchEnd := length - digitsToReserve

		window := bank[currentIndex:searchEnd]
		maxChar, relativeIdx := findMaxDigitInSlice(window)

		resultBuilder.WriteByte(maxChar)
		currentIndex = currentIndex + relativeIdx + 1
		needed--
	}

	finalVal, _ := strconv.ParseInt(resultBuilder.String(), 10, 64)
	return finalVal
}

/*
------------------------------------------------------------------------

	HELPER: Run Solver

------------------------------------------------------------------------
*/
func runSolver(label string, data []string) {
	var totalPart1 int64 = 0
	var totalPart2 int64 = 0

	for _, line := range data {
		totalPart1 += solvePart1(line)
		totalPart2 += solvePart2(line)
	}

	fmt.Printf("--- %s ---\n", label)
	fmt.Printf("Part 1 Total: %d\n", totalPart1)
	fmt.Printf("Part 2 Total: %d\n", totalPart2)
	fmt.Println()
}

/*
------------------------------------------------------------------------

	HELPER: File Loader

------------------------------------------------------------------------

	Reads a file line-by-line and returns a slice of strings.
*/
func loadInputFromFile(filename string) ([]string, error) {
	// 1. Open the file
	file, err := os.Open(filename)
	if err != nil {
		return nil, err
	}

	// 2. Schedule the file to close
	// 'defer' ensures this runs when the function exits, even if it crashes.
	defer file.Close()

	var lines []string

	// 3. Create a Scanner
	// bufio.Scanner is the easiest way to read text line-by-line.
	scanner := bufio.NewScanner(file)

	// 4. Loop through lines
	for scanner.Scan() {
		// scanner.Text() returns the current line as a string
		// We trim whitespace just in case
		line := strings.TrimSpace(scanner.Text())
		if line != "" {
			lines = append(lines, line)
		}
	}

	// 5. Check for errors that occurred during scanning
	if err := scanner.Err(); err != nil {
		return nil, err
	}

	return lines, nil
}

/*
------------------------------------------------------------------------

	MAIN ENTRY POINT

------------------------------------------------------------------------
*/
func main() {
	// 1. RUN SAMPLE DATA
	sampleData := []string{
		"987654321111111",
		"811111111111119",
		"234234234234278",
		"818181911112111",
	}
	runSolver("SAMPLE DATA", sampleData)

	// 2. RUN REAL DATA (FROM FILE)
	filename := "day3-data.txt"

	// Call our new file loader
	realData, err := loadInputFromFile(filename)

	if err != nil {
		// If file is missing, just print a friendly message
		fmt.Printf("--- REAL DATA ---\n")
		fmt.Printf("Could not read '%s'. Skipping.\n", filename)
		fmt.Println("Error details:", err)
	} else {
		// If successful, run the solver
		runSolver("REAL DATA", realData)
	}
}
