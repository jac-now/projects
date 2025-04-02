import subprocess
import sys
import platform

def run_command(command):
    """Runs an external command and prints the output."""
    try:
        result = subprocess.run(command, shell=True, capture_output=True, text=True, check=True)
        print("--- Command Output ---")
        print(result.stdout)
        print("--- Command Error ---")
        print(result.stderr)
        print(f"Return Code: {result.returncode}")
    except subprocess.CalledProcessError as e:
        print(f"Error running command: {e}")

if len(sys.argv) > 1:
    command_to_run = sys.argv[1]
    run_command(command_to_run)
else:
    print("Please provide a command as a command-line argument. If the full command contains spaces please wrap in quotes.")
    print(f"Example: python3 {sys.argv[0]} dir") #Windows example
    print(f"Example: python3 {sys.argv[0]} 'ls -l'") #Linux/macOS example