#!/usr/bin/env python3
# coding:utf-8
#author: Lazy Yao

'''
get device info command
adb start-server
adb shell getprop ro.product.model
adb shell getprop ro.build.version.release
adb shell getprop ro.build.version.sdk
'''

'''
app bundle install command:
java -jar bundletool.jar get-device-spec --output=SM.json --adb=adb
java -jar bundletool.jar build-apks --connected-device --adb=adb --bundle=StoryChic.aab 
--output=StoryChic.apks --ks=AndroidTestKey.jks --ks-pass=pass:111111 --ks-key-alias=key --key-pass=pass:111111
java -jar bundletool.jar install-apks --apks=StoryChic.apks --adb=adb
'''

'''
1.get device info
2.get aab package 
3.product apks file named by device info
'''
import os, subprocess, json

def get_parameter(path):
	temp = path +  "/config/config.json"
	with open(temp) as lf:
		jsonStr = lf.read()
		dic = json.loads(jsonStr, strict = False)
	adb_win = path + dic["adb_win"]
	jar_file = path + dic["jar_file"]
	ks_file = path + dic["ks_file"]
	ks_alias = dic["ks_alias"]
	ks_pass = dic["ks_pass"]
	return adb_win, jar_file, ks_file, ks_alias, ks_pass

def get_device_info():
	subprocess.getstatusoutput("adb start-server")
	_, model = subprocess.getstatusoutput("adb shell getprop ro.product.model")
	_, android_version = subprocess.getstatusoutput("adb shell getprop ro.build.version.release")
	_, sdk_version = subprocess.getstatusoutput("adb shell getprop ro.build.version.sdk")
	device_info = "_" + model + "_" + android_version + "_" + sdk_version
	return device_info

def get_aab_file(path):
	path += "/workspace"
	for root, dirs, files in os.walk(path):
		for file in files:
			if file[-3:] == "aab":
				aab_file = root + "/" + file
				ex_info = file[:-4]
				return aab_file, ex_info
	
def produce_json(jar_file, json_file, adb_file):
	command = "java -jar " + jar_file + " get-device-spec --output=" + json_file + " --adb=" + adb_file
	info = subprocess.getstatusoutput(command)
	print(info)

def produce_apks(jar_file, adb_file, aab_file, apks_file, ks_file, ks_pass, ks_alias):
	command = "java -jar " + jar_file + " build-apks --connected-device --adb=" + adb_file + " --bundle=" + aab_file + " --output=" + apks_file + " --ks=" + ks_file + " --ks-pass=" + ks_pass + " --ks-key-alias=" + ks_alias + " --key-pass=" + ks_pass
	info = subprocess.getstatusoutput(command)
	print(info)


def install_apks(jar_file, apks_file, adb_file):
	command = "java -jar " + jar_file + " install-apks --apks=" + apks_file + " --adb=" + adb_file
	info = subprocess.getstatusoutput(command)
	print(info)


def clean_produce_file(path):
	temp = path + "/workspace"
	for root, dirs, files in os.walk(temp):
		for file in files:
			if file[-4:] == "json":
				json_file = root + "/" + file
				os.remove(json_file)
				print("删除遗留json文件成功！")
			if file[-4:] == "apks":
				apks_file = root + "/" + file
				os.remove(apks_file)
				print("删除遗留apks文件成功！")


if __name__ == "__main__":
	path = os.path.dirname(__file__)
	adb_file, jar_file, ks_file, ks_alias, ks_pass = get_parameter(path)
	print(jar_file)
	aab_file, ex_info = get_aab_file(path)
	json_file = path + "/workspace/" + ex_info + get_device_info() + ".json"
	print(json_file)
	apks_file = path + "/workspace/" + ex_info + get_device_info() + ".apks"
	print("---------------------")
	clean_produce_file(path)
	print("---------------------")
	print("生成json文件")
	produce_json(jar_file, json_file, adb_file)
	print("生成apks文件")
	produce_apks(jar_file, adb_file, aab_file, apks_file, ks_file, ks_pass, ks_alias)
	print("正在安装apk.........")
	install_apks(jar_file, apks_file, adb_file)
	print("安装完成")