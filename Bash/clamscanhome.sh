#!/bin/bash

freshclam &&
clamscan -r /home/ --infected --log /var/log/ClamScanHome.log