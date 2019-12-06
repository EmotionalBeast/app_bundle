
##使用说明

1.将.aab文件放入workspace文件夹里
2.运行app_bundle_install.bat批处理文件，即可安装到测试机


##批处理文件功能说明

1.app_bundle_install.bat 		将.aab抽取成特定的apk安装到测试机上
2.app_bundle_clear_build.bat		清理安装过程中产生的缓存文件

一般使用上面这两个bat文件就可以。

3.build_apks_from_aab.bat		从.aab文件中抽取.apks文件
4.install_app_from_apks.bat		从.apks文件中抽取特定的apk文件，并安装到测试机
5.app_bundle_build_universal.bat	针对4.4及以下系统，抽取出全量apks文件，解压后可获得apk文件

##其他注意事项
1.文件夹路径不能有中文和空格
2.安装时，必须保证只连接一个测试机
