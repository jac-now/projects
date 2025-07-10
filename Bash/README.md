# Bash Scripts

This directory contains a collection of Bash scripts for various system administration tasks.

## Scripts

- **clamscanhome.sh**: Updates the ClamAV database and runs a recursive scan of the `/home` directory, logging infected files to `/var/log/ClamScanHome.log`.
- **clamscanrootfs.sh**: Updates the ClamAV database and runs a recursive scan of the root filesystem (`/`), logging infected files to `/var/log/ClamScan.log`.
- **pingsweep.sh**: Performs a simple ping sweep of a /24 network to identify live hosts. Requires the first three octets of the network as an argument (e.g., `./pingsweep.sh 192.168.1`).
