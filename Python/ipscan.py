import socket
import subprocess
import time

def get_os(): #Asks the user for their OS
    while True:
        os_type = input("Enter your operating system (*nix or Windows): ").lower()
        if os_type in ["nix", "windows"]:
            return os_type
        else:
            print("Invalid input. Please enter either 'nix' or 'Windows'.")

def get_ip_prefix(): #Asks user for the first 3 octets of their network
    while True:
        ip_prefix = input("Enter the first three octets of the IP address (e.g., 192.168.1): ")
        if validate_ip_prefix(ip_prefix):
            return ip_prefix
        else:
            print("Invalid IP prefix. Please try again.")

def validate_ip_prefix(prefix): #Validates that the entered IP prefix is in the correct format
    parts = prefix.split(".")
    return len(parts) == 3 and all(0 <= int(part) <= 255 for part in parts)

def is_online(ip, os_type): #Pings a host to check if it's online
    ping_cmd = ["ping", "-n", "1"] if os_type == "windows" else ["ping", "-c", "1"]
    try:
        #print(f"Executing: {' '.join(ping_cmd + [ip])}") #Debug line - prints command being executed to track where at in pings
        output = subprocess.check_output(ping_cmd + [ip], timeout=10) #Timeout set to 10 seconds adjust as needed
        if  "Destination host unreachable" in str(output) or "Request timed out" in str(output): #Checks for errors
            #print(f"Ping to {ip} failed (Destination unreachable or timed out)")  #Debug line
            return False
        return True  
    except subprocess.CalledProcessError as e:
        #print(f"Ping to {ip} failed (Other Error)")
        #print(f"Error Output: {e.output}")  
        return False
    finally:
        #print("Entered the finally block")  # Debug line
        if 'e' in locals():
            if hasattr(e, 'process'):  # Handle cases where no process was started
                e.process.terminate()  # Terminate if a process exists
                e.process.wait()  # Wait for it to actually finish

def scan_network(ip_prefix): #Scans the network and reports online hosts with hostnames.
    os_type = get_os()  #Get the OS from the user
    for i in range(1, 255):
        ip = ip_prefix + "." + str(i)
        if is_online(ip, os_type):
            try:
                hostname = socket.gethostbyaddr(ip)[0]
                print(f"Host at {ip} ({hostname}) is online.")
            except socket.herror:
                print(f"Host at {ip} is online but hostname could not be resolved.")
        time.sleep(5) #Adjust time as needed to throttle processes, or to create less noise
if __name__ == "__main__":
    ip_prefix = get_ip_prefix()
    scan_network(ip_prefix)
