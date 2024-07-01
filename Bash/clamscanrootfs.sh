#!/bin/bash

freshclam &&
clamscan -r / --infected --log /var/log/Clamscan.log