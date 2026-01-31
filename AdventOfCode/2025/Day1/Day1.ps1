<#
.AUTHOR Jac-Now

.SYNOPSIS
    Day 1: Secret Entrance (PowerShell Edition)
    
.DESCRIPTION
    This script solves the safe dial puzzle.
    It demonstrates file reading, loops, modular arithmetic, and string parsing.

.NOTES
    How to run: 
    1. Open PowerShell
    2. Navigate to folder
    3. Run: .\day1.ps1
#>

# ------------------------------------------------------------------------
# HELPER: Mathematical Modulo
# ------------------------------------------------------------------------
# PowerShell, like Go/C#, returns negative numbers for modulo (-1 % 100 = -1).
# We need a helper to force "Python style" positive wrapping.
function Get-PositiveMod {
    param (
        [int]$n,
        [int]$m
    )
    # The math formula: ((n % m) + m) % m
    return (($n % $m) + $m) % $m
}

# ------------------------------------------------------------------------
# PART 1: The Teleport Method
# ------------------------------------------------------------------------
function Get-Part1Solution {
    param (
        [string[]]$Instructions # Expecting an array of strings
    )

    # Variables in PowerShell always start with $
    $CurrentPos = 50
    $ZeroCount = 0

    # 'foreach' is like Python's 'for item in list'
    foreach ($Step in $Instructions) {
        
        # PARSING
        # Strings are character arrays. Index 0 is the letter.
        $Direction = $Step[0] 
        
        # .Substring(1) cuts the string from index 1 to the end.
        # [int] casts the string "68" into the number 68.
        $Amount = [int]$Step.Substring(1)

        # LOGIC
        # Note the operators: '-eq' means '==', '-lt' means '<', etc.
        if ($Direction -eq 'R') {
            # Parentheses are required for math expressions usually
            $CurrentPos = ($CurrentPos + $Amount) % 100
        }
        elseif ($Direction -eq 'L') {
            # Use our helper function for subtraction
            $CurrentPos = Get-PositiveMod -n ($CurrentPos - $Amount) -m 100
        }

        if ($CurrentPos -eq 0) {
            $ZeroCount++ # ++ works the same as Go/C
        }
    }

    # In PowerShell, we don't strictly need 'return'. 
    # The last value evaluated is sent back. But 'return' is clearer.
    return $ZeroCount
}

# ------------------------------------------------------------------------
# PART 2: The Simulation Method
# ------------------------------------------------------------------------
function Get-Part2Solution {
    param (
        [string[]]$Instructions
    )

    $CurrentPos = 50
    $ZeroCount = 0

    foreach ($Step in $Instructions) {
        $Direction = $Step[0]
        $Amount = [int]$Step.Substring(1)

        # INNER LOOP
        # Standard C-style loop syntax: (Init; Condition; Increment)
        for ($i = 0; $i -lt $Amount; $i++) {
            
            if ($Direction -eq 'R') {
                $CurrentPos = ($CurrentPos + 1) % 100
            }
            elseif ($Direction -eq 'L') {
                $CurrentPos = Get-PositiveMod -n ($CurrentPos - 1) -m 100
            }

            # Check every single click
            if ($CurrentPos -eq 0) {
                $ZeroCount++
            }
        }
    }

    return $ZeroCount
}

# ------------------------------------------------------------------------
# MAIN EXECUTION
# ------------------------------------------------------------------------

# 1. Read the file
# Get-Content is the standard command to read a text file.
# We assume input.txt is in the same directory.
$InputFile = "day1-data.txt"

# Check if file exists to prevent ugly red errors
if (Test-Path $InputFile) {
    
    # Read file into an array variable
    $Data = Get-Content -Path $InputFile

    # 2. Run Part 1
    # To call a function, use space separation (not parentheses!)
    $Part1Result = Get-Part1Solution -Instructions $Data
    
    # Write-Host is like print()
    Write-Host "Part 1 Password: $Part1Result" -ForegroundColor Cyan

    # 3. Run Part 2
    $Part2Result = Get-Part2Solution -Instructions $Data
    Write-Host "Part 2 Password: $Part2Result" -ForegroundColor Green

} else {
    Write-Error "Could not find 'input.txt'. Make sure it is in the same folder!"
}