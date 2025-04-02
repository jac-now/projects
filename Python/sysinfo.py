import os
import sys
import platform
import socket
import getpass
#import netifaces #install with pip3 install netifaces

def get_detailed_system_info():
    #Retrieves and prints detailed system information

    #Operating System Information
    print("--- Operating System Info ---")
    print(f"  Operating System: {platform.system()}")
    print(f"  OS Version: {platform.version()}")
    print(f"  OS Release: {platform.release()}")
    print(f"  OS Architecture: {platform.architecture()}")

    #Network Information
    print("\n### Network Info ###")
    try:
        hostname = socket.gethostname()
        print(f"  Hostname: {hostname}")
        ip_address = socket.gethostbyname(hostname)
        print(f"  IP Address: {ip_address}")
        # #Get all interfaces and their IP addresses
        #  interfaces = netifaces.interfaces()
        # for interface in interfaces:
        #     addresses = netifaces.ifaddresses(interface)
        #     if socket.AF_INET in addresses:
        #         for addr_info in addresses[socket.AF_INET]:
        #             ip_address = addr_info['addr']
        #             print(f"  Interface: {interface}, IP Address: {ip_address}")
    except socket.gaierror:
        print("  Could not retrieve network information.")

    # User Information
    print("\n### User Info ###")
    print(f"  Logged-in User: {getpass.getuser()}")

    # Python Information
    print("\n### Python Info ###")
    print(f"  Python Version: {sys.version}")
    print(f"  Python Executable: {sys.executable}")

    # Environment Variables
    print("\n### Environment Variables ###")
    print(f"  PATH: {os.environ.get('PATH')}")

get_detailed_system_info()