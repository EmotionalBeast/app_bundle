#!/usr/bin/env python3
#coding: utf-8
#clear content of workspace
#anthor Yao Jing

import subprocess, os
workPath = "./workspace"
for root,dirs,files in os.walk(workPath):
    for dir in dirs:
        currentPath = root + "/" + dir
        # subprocess.run(["rm","-r",currentPath])
        subprocess.getoutput("rm -r currentPath")

