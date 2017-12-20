@echo off


::获取管理员权限
%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0 ::","","runas",1)(window.close)&&exit
::将目录切换到脚本所在目录
cd /d %~dp0

SETLOCAL ENABLEDELAYEDEXPANSION

set zip=C:\Program Files\WinRAR\WinRAR.exe
set javadir=D:\q\Java
set tomcatdir=D:\q
set myjdkpath=D:\q\Java\jdk1.8.0_151_32
set mytomcatpath=D:\q\apache-tomcat-8.5.23
set cspath=C:\
set cygwindir=C:\cygwin


if not exist %javadir% (md %javadir%)
if not exist %cygwindir% (md %cygwindir%)


echo **********************************************
echo.
echo          将要安装cygwin和WinRar x64或x86
echo.
echo **********************************************
if /i %PROCESSOR_IDENTIFIER:~0,3%==x86 (
  echo 32位操作系统
  start /wait software\wrar550scp.exe /s
  if %errorlevel%==0 (echo  WinRAR x86 -- OK) else (echo  WinRAR x86 -- error)
  
  "%zip%" x -o+ "software\cygwin_32_bin.rar" "%cygwindir%"
) else (
  echo 64位操作系统
  start /wait software\winrar-x64-550scp.exe /s
  if %errorlevel%==0 (echo  WinRAR x64 -- OK) else (echo  WinRAR x64 -- error)
  
  "%zip%" x -o+ "software\cygwin_64_bin.rar" "%cygwindir%"
)




echo **********************************************
echo.
echo            将要解压jdk、tomcat和adb
echo.
echo **********************************************

::pause

echo.
echo 正在解压，请不要执行其他操作
echo.
echo 请稍等，这个时间大约需要二、三分钟
echo.
::for %%i in (*.zip) do "%zip%" x -o+ "%%i"
"%zip%" x -o+ "jdk1.8.0_151_32.zip" "%javadir%"
"%zip%" x -o+ "apache-tomcat-8.5.23_32.zip" "%tomcatdir%"
"%zip%" x -o+ "software\ADB.rar" "%tomcatdir%"
echo 解压jdk、tomcat和adb到"%javadir%"和"%tomcatdir%"




echo ******************************************************
echo.
echo     将要配置中软需要的文件(需要放在管理员权限之外)    
echo.
echo ******************************************************

set /P CHS= Choose Please(y-执行/n-不执行):
if '%CHS%' == 'y' (
  ::set csdir="C:\cshis"
  ::set tmpdir="C:\Temp"
  ::if not exist "%csdir%" md "%csdir%"
  ::xcopy "cshis" "%csdir%" /c/e/q/y 
  "%zip%" x -o+ "cshis.rar" "%cspath%"

  ::if not exist "%tmpdir%" md "%tmpdir%"
  ::xcopy "Temp" "%tmpdir%" /c/e/q/y 
  ::xcopy "cshis\*.*" "C:\" /s /h /d /y >nul
  ::xcopy "Temp\*.*" "C:\" /s /h /d /y >nul
  "%zip%" x -o+ "Temp.rar" "%cspath%"

  echo 中软需要的文件配置成功
  echo 如果是中软的机器，记得更新对应的dll文件到jdk
) else (
  echo 不配置中软需要的文件，该逻辑跳过
)



echo **********************************************
echo.
echo             将要配置环境变量
echo.
echo       继续请按任意键，退出直接关闭窗口
echo.
echo **********************************************
::pause


::删除java环境变量
wmic environment where "name='JAVA_HOME' and username='<system>'" delete
wmic environment where "name='JRE_HOME' and username='<system>'" delete
wmic environment where "name='CLASSPATH' and username='<system>'" delete
::添加java环境变量
wmic environment create name="LANG",username="<system>",VariableValue="zh_CN"
wmic environment create name="JAVA_HOME",username="<system>",VariableValue="%myjdkpath%"
wmic environment create name="JRE_HOME",username="<system>",VariableValue="%%JAVA_HOME%%\jre"
wmic environment create name="CLASSPATH",username="<system>",VariableValue=".;%%JAVA_HOME%%\lib\tools.jar;%%JAVA_HOME%%\lib\dt.jar;%%JAVA_HOME%%\jre\lib\rt.jar"

for /f "tokens=2 delims==" %%i in ('wmic environment where "name='Path' and UserName='<system>'" get VariableValue /value') do (
	wmic environment where "name='PATH' and username='<system>'" set VariableValue="%%i;%%JAVA_HOME%%\bin;%cygwindir%\bin")

::删除和添加新的tomcat环境变量
wmic environment where "name='CATALINA_HOME' and username='<system>'" delete
wmic environment create name="CATALINA_HOME",username="<system>",VariableValue="%mytomcatpath%"

echo 环境变量配置成功，需要重启计算机方可生效
pause



echo **********************************************
echo.
echo       设置自动清理7天前的tomcat日志
echo.
echo **********************************************

at 00:10 /every:Sunday,Monday,Tuesday,Wednesday,Thursday,Friday,Saturday forfiles /p %mytomcatpath%\logs /s /m *.* /d -7 /c "cmd /c del @path"

echo 设置自动清理7天前的tomcat日志完成



echo 5s后将重启计算机
::重启计算机
shutdown /r /t 5