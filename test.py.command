#!/usr/bin/env python3
# coding:utf-8

import os, subprocess
path = os.path.dirname(__file__)
print(path)

_,info = subprocess.getstatusoutput("ls -lah")
print(info)

subprocess.getstatusoutput("adb start-server")
