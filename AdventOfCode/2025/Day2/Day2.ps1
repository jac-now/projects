<#
.AUTHOR Jac-Now

.SYNOPSIS
    Day 2: Gift Shop (PowerShell Edition)
    
.DESCRIPTION
    Solves the invalid ID puzzle by parsing ranges and checking string patterns.
    Includes logic for both Part 1 (Exact Halves) and Part 2 (Repeated Chunks).

.NOTES
    How to run: 
    1. Open PowerShell
    2. Navigate to the folder containing this script
    3. Run: .\Day2.ps1
#>

# ==========================================
# HELPER FUNCTIONS
# ==========================================

function Test-PatternPart1 {
    param (
        [long]$Num
    )
    # 1. Convert to string
    $s = [string]$Num
    $len = $s.Length

    # 2. Optimization: Odd lengths can't be split evenly
    if ($len % 2 -ne 0) {
        return $false
    }

    # 3. Split and Compare
    $mid = $len / 2
    
    # .Substring(start, length)
    $firstHalf = $s.Substring(0, $mid)
    # .Substring(start) goes to the end
    $secondHalf = $s.Substring($mid)

    # Powershell comparison: -eq
    return $firstHalf -eq $secondHalf
}

function Test-PatternPart2 {
    param (
        [long]$Num
    )
    $s = [string]$Num
    $len = $s.Length

    # Iterate from chunk size 1 up to half the length
    # Note: -le means "Less than or Equal to"
    for ($i = 1; $i -le ($len / 2); $i++) {
        
        # Optimization: Check divisibility
        if ($len % $i -ne 0) {
            continue
        }

        # Define pattern candidate
        $pattern = $s.Substring(0, $i)
        
        # Calculate repeats needed
        # [Math]::Floor isn't strictly needed for integer division here, 
        # but PS division / defaults to decimal, so we cast to [int].
        $multiplier = [int]($len / $i)

        # Reconstruct String
        # PowerShell supports string multiplication! "abc" * 3 = "abcabcabc"
        $reconstructed = $pattern * $multiplier

        if ($reconstructed -eq $s) {
            return $true
        }
    }
    return $false
}

function Get-Solution {
    param (
        [string]$InputString,
        [int]$Part # 1 or 2
    )

    # Use [long] (Int64) for the sum to prevent overflow if numbers get huge
    [long]$TotalSum = 0

    # 1. Split by comma
    $Ranges = $InputString.Split(',')

    foreach ($Range in $Ranges) {
        # Defensive Coding: Trim whitespace
        $Range = $Range.Trim()
        
        # Skip empty strings (fix for trailing commas)
        if ([string]::IsNullOrWhiteSpace($Range)) { continue }

        # 2. Parse Start and End
        $Parts = $Range.Split('-')
        
        # Safety Check
        if ($Parts.Count -ne 2) { continue }

        $Start = [long]$Parts[0]
        $End   = [long]$Parts[1]

        # 3. Loop through the range
        # We use a for loop instead of ($Start..$End) to save memory
        for ($Num = $Start; $Num -le $End; $Num++) {
            
            $IsMatch = $false
            
            if ($Part -eq 1) {
                $IsMatch = Test-PatternPart1 -Num $Num
            } else {
                $IsMatch = Test-PatternPart2 -Num $Num
            }

            if ($IsMatch) {
                $TotalSum += $Num
            }
        }
    }

    return $TotalSum
}

# ==========================================
# MAIN EXECUTION
# ==========================================

# 1. CONFIGURATION
# Set to $true to use the example, $false for real data
$UseSampleData = $false

$SampleData = "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124"

# PASTE YOUR MASSIVE STRING HERE (Inside the @" "@ block)
# This is a "Here-String", perfect for multi-line or massive text
$RealData = "853-1994,1919078809-1919280414,1212082623-1212155811,2389-4173,863031-957102,9393261874-9393318257,541406-571080,1207634-1357714,36706-61095,6969667126-6969740758,761827-786237,5516637-5602471,211490-235924,282259781-282327082,587606-694322,960371-1022108,246136-353607,3-20,99-182,166156087-166181497,422-815,82805006-82876926,14165-30447,4775-7265,83298136-83428425,2439997-2463364,44-89,435793-511395,3291059-3440895,77768624-77786844,186-295,62668-105646,7490-11616,23-41,22951285-23017127"

# 2. SELECT DATA
if ($UseSampleData) {
    Write-Host "--- RUNNING WITH SAMPLE DATA ---" -ForegroundColor Cyan
    $Data = $SampleData
} else {
    Write-Host "--- RUNNING WITH REAL DATA ---" -ForegroundColor Cyan
    # Remove newlines just in case the paste introduced them
    $Data = $RealData -replace "`r`n", "" -replace "`n", ""
}

# 3. RUN PART 1
$Result1 = Get-Solution -InputString $Data -Part 1
Write-Host "Part 1 Sum: $Result1" -ForegroundColor Green

# 4. RUN PART 2
$Result2 = Get-Solution -InputString $Data -Part 2
Write-Host "Part 2 Sum: $Result2" -ForegroundColor Green