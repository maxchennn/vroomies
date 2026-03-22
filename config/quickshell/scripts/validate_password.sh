#!/usr/bin/env python3

import os
import sys
import pam

check = sys.argv[1]

p = pam.pam()

serv = os.getenv("LOCKSCREEN_PAM_SERVICE", "system-auth")

print(f"PAM Service: {serv}", file=sys.stderr)

if p.authenticate(os.getenv("USER"), check, service = serv):
    print("yes")
    exit(0)

print("no")
