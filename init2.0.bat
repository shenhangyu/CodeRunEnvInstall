@echo off


::��ȡ����ԱȨ��
%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0 ::","","runas",1)(window.close)&&exit
::��Ŀ¼�л����ű�����Ŀ¼
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
echo          ��Ҫ��װcygwin��WinRar x64��x86
echo.
echo **********************************************
if /i %PROCESSOR_IDENTIFIER:~0,3%==x86 (
  echo 32λ����ϵͳ
  start /wait software\wrar550scp.exe /s
  if %errorlevel%==0 (echo  WinRAR x86 -- OK) else (echo  WinRAR x86 -- error)
  
  "%zip%" x -o+ "software\cygwin_32_bin.rar" "%cygwindir%"
) else (
  echo 64λ����ϵͳ
  start /wait software\winrar-x64-550scp.exe /s
  if %errorlevel%==0 (echo  WinRAR x64 -- OK) else (echo  WinRAR x64 -- error)
  
  "%zip%" x -o+ "software\cygwin_64_bin.rar" "%cygwindir%"
)




echo **********************************************
echo.
echo            ��Ҫ��ѹjdk��tomcat��adb
echo.
echo **********************************************

::pause

echo.
echo ���ڽ�ѹ���벻Ҫִ����������
echo.
echo ���Եȣ����ʱ���Լ��Ҫ����������
echo.
::for %%i in (*.zip) do "%zip%" x -o+ "%%i"
"%zip%" x -o+ "jdk1.8.0_151_32.zip" "%javadir%"
"%zip%" x -o+ "apache-tomcat-8.5.23_32.zip" "%tomcatdir%"
"%zip%" x -o+ "software\ADB.rar" "%tomcatdir%"
echo ��ѹjdk��tomcat��adb��"%javadir%"��"%tomcatdir%"




echo ******************************************************
echo.
echo     ��Ҫ����������Ҫ���ļ�(��Ҫ���ڹ���ԱȨ��֮��)    
echo.
echo ******************************************************

set /P CHS= Choose Please(y-ִ��/n-��ִ��):
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

  echo ������Ҫ���ļ����óɹ�
  echo ���������Ļ������ǵø��¶�Ӧ��dll�ļ���jdk
) else (
  echo ������������Ҫ���ļ������߼�����
)



echo **********************************************
echo.
echo             ��Ҫ���û�������
echo.
echo       �����밴��������˳�ֱ�ӹرմ���
echo.
echo **********************************************
::pause


::ɾ��java��������
wmic environment where "name='JAVA_HOME' and username='<system>'" delete
wmic environment where "name='JRE_HOME' and username='<system>'" delete
wmic environment where "name='CLASSPATH' and username='<system>'" delete
::���java��������
wmic environment create name="LANG",username="<system>",VariableValue="zh_CN"
wmic environment create name="JAVA_HOME",username="<system>",VariableValue="%myjdkpath%"
wmic environment create name="JRE_HOME",username="<system>",VariableValue="%%JAVA_HOME%%\jre"
wmic environment create name="CLASSPATH",username="<system>",VariableValue=".;%%JAVA_HOME%%\lib\tools.jar;%%JAVA_HOME%%\lib\dt.jar;%%JAVA_HOME%%\jre\lib\rt.jar"

for /f "tokens=2 delims==" %%i in ('wmic environment where "name='Path' and UserName='<system>'" get VariableValue /value') do (
	wmic environment where "name='PATH' and username='<system>'" set VariableValue="%%i;%%JAVA_HOME%%\bin;%cygwindir%\bin")

::ɾ��������µ�tomcat��������
wmic environment where "name='CATALINA_HOME' and username='<system>'" delete
wmic environment create name="CATALINA_HOME",username="<system>",VariableValue="%mytomcatpath%"

echo �����������óɹ�����Ҫ���������������Ч
pause



echo **********************************************
echo.
echo       �����Զ�����7��ǰ��tomcat��־
echo.
echo **********************************************

at 00:10 /every:Sunday,Monday,Tuesday,Wednesday,Thursday,Friday,Saturday forfiles /p %mytomcatpath%\logs /s /m *.* /d -7 /c "cmd /c del @path"

echo �����Զ�����7��ǰ��tomcat��־���



echo 5s�����������
::���������
shutdown /r /t 5