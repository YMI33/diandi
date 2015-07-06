关于发布的方法(有问题)：
	打包所有文件为 package.nw 注意，文件名一定得是这个才行！
	放入release文件夹中。
	双击nw.exe即可。

或者，可以（有问题）：
	打包所有文件为xxx.nw，这个名字可以任取。
	放入release文件夹中。
	把该文件拖入nw.exe即可。

===========================================================
关于nodejs，nodewebkit环境的搭建：
	安装nodewebkit：
		简单，下载解压就行http://dl.node-webkit.org/v0.9.2/node-webkit-v0.9.2-win-ia32.zip。
	安装nodejs(必须先安装python才行):
		下载安装地址：官网http://www.nodejs.org/download/ 
============================================================

现在发布的方法：
不采用压缩包发布，因为发现无法改变压缩文件中的yanwu.txt zhinent.txt renti.txt文件内容！这个问题有待研究。
暂时的发布方式为直接写个批处理，切换到nw.exe目录，把工程文件夹也放到该目录下，执行"nw.exe proj"即可。

发布时，把smartDeviceTester整个文件夹拷贝到目标电脑的E盘根目录，再把批处理拷贝到目标电脑的桌面，双击.bat就可以执行了。

===================
如何新建一个项目？
非常简单，先建立如helloWorldDemo类似的目录结构，把下载的node-webkit的最新released包打开，把nw.exe，nw.apk，icudt.dll三个文件放到项目目录下，双击nw.exe就可以运行程序了
