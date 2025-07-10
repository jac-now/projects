#!/bin/bash

freshclam &&
clamscan -r / --infected --log /var/log/ClamScan.log