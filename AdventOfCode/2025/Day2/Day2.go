package main

import (
	"fmt"
	"strconv" // Used for converting Strings <-> Integers
	"strings" // Used for string manipulation (Split, Repeat, etc.)
)

/*
------------------------------------------------------------------------

	HELPER: Part 1 Pattern Check

------------------------------------------------------------------------

	Logic: Check if the string is split into two exact identical halves.
	Example: "1212" -> "12" == "12" (True)
*/
func checkPatternPart1(num int) bool {
	// 1. Convert integer to string so we can slice it
	// strconv.Itoa = "Integer to ASCII"
	s := strconv.Itoa(num)
	length := len(s)

	// 2. Optimization: Odd lengths can't be split evenly into two
	if length%2 != 0 {
		return false
	}

	// 3. Slice and Compare
	mid := length / 2

	// Go slicing works exactly like Python: [start:end]
	firstHalf := s[:mid]
	secondHalf := s[mid:]

	return firstHalf == secondHalf
}

/*
------------------------------------------------------------------------

	HELPER: Part 2 Pattern Check

------------------------------------------------------------------------

	Logic: Check if string is built from a chunk repeated N times.
	Example: "121212" -> "12" repeated 3 times (True)
*/
func checkPatternPart2(num int) bool {
	s := strconv.Itoa(num)
	length := len(s)

	// We iterate from chunk size 1 up to half the length.
	// Go Loop Syntax: for init; condition; post
	for i := 1; i <= length/2; i++ {

		// Optimization: If the total length isn't divisible by the chunk size,
		// it's mathematically impossible to fit perfectly. Skip.
		if length%i != 0 {
			continue
		}

		// Define the pattern candidate (first 'i' chars)
		pattern := s[:i]

		// Calculate how many times it needs to repeat
		multiplier := length / i

		// Reconstruct the string and compare.
		// In Python: pattern * multiplier
		// In Go: strings.Repeat(pattern, multiplier)
		if strings.Repeat(pattern, multiplier) == s {
			return true
		}
	}
	return false
}

/*
------------------------------------------------------------------------

	SOLVER: Process Ranges

------------------------------------------------------------------------

	Parses the input string "10-20,30-40..." and sums valid IDs.
	The 'part' argument (1 or 2) decides which check function to use.
*/
func processRanges(input string, part int) int {
	totalSum := 0

	// 1. Split the massive string by comma to get individual ranges
	// strings.TrimSpace removes potential accidental newlines at the end
	ranges := strings.Split(strings.TrimSpace(input), ",")

	// Loop through every range string
	// "_" ignores the index, "r" is the value (e.g., "11-22")
	for _, r := range ranges {

		// 2. Parse the Start and End
		parts := strings.Split(r, "-")

		// Convert string to int. We ignore errors (_) for simplicity here.
		start, _ := strconv.Atoi(parts[0])
		end, _ := strconv.Atoi(parts[1])

		// 3. Loop through the range
		// Note: <= end ensures we include the last number (Inclusive)
		for num := start; num <= end; num++ {

			// Decide which logic to apply
			matched := false
			if part == 1 {
				matched = checkPatternPart1(num)
			} else {
				matched = checkPatternPart2(num)
			}

			// 4. Accumulate if valid
			if matched {
				totalSum += num
			}
		}
	}
	return totalSum
}

/*
------------------------------------------------------------------------

	MAIN ENTRY POINT

------------------------------------------------------------------------
*/
func main() {
	// ==========================================
	// CONFIGURATION
	// ==========================================

	// Set this to TRUE to test logic, FALSE to solve the puzzle
	useSampleData := false

	// The example data provided in the text
	sampleData := "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124"

	// PASTE YOUR REAL DATA HERE (One long string)
	realData := "853-1994,1919078809-1919280414,1212082623-1212155811,2389-4173,863031-957102,9393261874-9393318257,541406-571080,1207634-1357714,36706-61095,6969667126-6969740758,761827-786237,5516637-5602471,211490-235924,282259781-282327082,587606-694322,960371-1022108,246136-353607,3-20,99-182,166156087-166181497,422-815,82805006-82876926,14165-30447,4775-7265,83298136-83428425,2439997-2463364,44-89,435793-511395,3291059-3440895,77768624-77786844,186-295,62668-105646,7490-11616,23-41,22951285-23017127"

	// ==========================================
	// EXECUTION
	// ==========================================
	var data string

	if useSampleData {
		fmt.Println("--- RUNNING WITH SAMPLE DATA ---")
		data = sampleData
	} else {
		fmt.Println("--- RUNNING WITH REAL DATA ---")
		data = realData
	}

	// --- PART 1 ---
	result1 := processRanges(data, 1)
	fmt.Printf("Part 1 Sum: %d\n", result1)

	// --- PART 2 ---
	result2 := processRanges(data, 2)
	fmt.Printf("Part 2 Sum: %d\n", result2)
}
