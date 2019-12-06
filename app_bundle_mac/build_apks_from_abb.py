#!/usr/bin/env python3
#coding: utf-8

import subprocess, os

workPath = "./workspace"
adbExe = "./config/adb.exe"
bundletool = "./config/bundletool.jar"
ksFile = "./config/AndroidTestKey.jks"
ksPass = "pass:111111"
ksAlias = "key"

for root, dirs, files in os.walk(workPath):
    for file in files:
        file[-3:] == "abb"
        target_aab == root + "/" + file    
        subprocess.getoutput("java -jar bundletool build-apks --bundle=target_aab --output=!output_apks! --ks=ksFile --ks-pass=ksPass  --ks-key-alias=ksAlias --key-pass=ksPass")

java -jar ./config/bundletool.jar get-device-spec --output=./workspace/deivceInfo.txt --adb=./config/adb.exe

java -jar ./config/bundletool.jar build-apks --connected-device --adb=./config/adb.exe --bundle=./workspace/bundle.abb --output=./config/bundle.apks --ks=./config/AndroidTestKey.jks --ks-pass=pass:111111  --ks-key-alias=%ks_alias% --key-pass=%ks_pass%

java -jar %bundletooljar% install-apks --apks=!output_apks! --adb=%adbexe%