@echo off

SETLOCAL ENABLEDELAYEDEXPANSION 

set zip=C:\Program Files\WinRAR\WinRAR.exe
set myjdkpath=D:\q\Java\jdk1.8.0_151_32
set myjrepath=D:\q\Java\jdk1.8.0_151_32\jre
set mytomcatpath=D:\q\apache-tomcat-8.5.23_32


echo **********************************************
echo.
echo              将要解压jdk和tomcat
echo.
echo       安装请按任意键，退出直接关闭窗口
echo.
echo **********************************************

::pause

echo.
echo 正在解压，请不要执行其他操作
echo.
echo 请稍等，这个时间大约需要二、三分钟
echo.
::for %%i in (*.zip) do "%zip%" x -o+ "%%i"
"%zip%" x -o+ "jdk1.8.0_151_32.zip" %myjdkpath%
"%zip%" x -o+ "apache-tomcat-8.5.23_32.zip" %mytomcatpath%
echo 解压jdk和tomcat到%myjdkpath%和%mytomcatpath%



echo **********************************************
echo.
echo             将要配置环境变量
echo.
echo       继续请按任意键，退出直接关闭窗口
echo.
echo **********************************************
::pause

::获取管理员权限
%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0 ::","","runas",1)(window.close)&&exit
wmic environment create name="JRE_HOME",username="<system>",VariableValue="%myjrepath%">nul
wmic environment create name="JAVA_HOME",username="<system>",VariableValue="%myjdkpath%">nul
wmic environment create name="CLASSPATH",username="<system>",VariableValue=".;%myjdkpath%\lib\tools.jar;%myjdkpath%\lib\dt.jar;%myjdkpath%\jre\lib\rt.jar">nul
for /f "tokens=2 delims==" %%i in ('wmic environment where "name='Path' and UserName='<system>'" get VariableValue /value') do (
	wmic environment where "name='PATH' and username='<system>'" set VariableValue=%%i;%myjdkpath%\bin)>nul
	
wmic environment create name="CATALINA_HOME",username="<system>",VariableValue="%mytomcatpath%">nul

echo 环境变量配置成功
pause