@echo off

SETLOCAL ENABLEDELAYEDEXPANSION 

set zip=C:\Program Files\WinRAR\WinRAR.exe
set myjdkpath=D:\q\Java\jdk1.8.0_151_32
set myjrepath=D:\q\Java\jdk1.8.0_151_32\jre
set mytomcatpath=D:\q\apache-tomcat-8.5.23_32


echo **********************************************
echo.
echo              ��Ҫ��ѹjdk��tomcat
echo.
echo       ��װ�밴��������˳�ֱ�ӹرմ���
echo.
echo **********************************************

::pause

echo.
echo ���ڽ�ѹ���벻Ҫִ����������
echo.
echo ���Եȣ����ʱ���Լ��Ҫ����������
echo.
::for %%i in (*.zip) do "%zip%" x -o+ "%%i"
"%zip%" x -o+ "jdk1.8.0_151_32.zip" %myjdkpath%
"%zip%" x -o+ "apache-tomcat-8.5.23_32.zip" %mytomcatpath%
echo ��ѹjdk��tomcat��%myjdkpath%��%mytomcatpath%



echo **********************************************
echo.
echo             ��Ҫ���û�������
echo.
echo       �����밴��������˳�ֱ�ӹرմ���
echo.
echo **********************************************
::pause

::��ȡ����ԱȨ��
%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0 ::","","runas",1)(window.close)&&exit
wmic environment create name="JRE_HOME",username="<system>",VariableValue="%myjrepath%">nul
wmic environment create name="JAVA_HOME",username="<system>",VariableValue="%myjdkpath%">nul
wmic environment create name="CLASSPATH",username="<system>",VariableValue=".;%myjdkpath%\lib\tools.jar;%myjdkpath%\lib\dt.jar;%myjdkpath%\jre\lib\rt.jar">nul
for /f "tokens=2 delims==" %%i in ('wmic environment where "name='Path' and UserName='<system>'" get VariableValue /value') do (
	wmic environment where "name='PATH' and username='<system>'" set VariableValue=%%i;%myjdkpath%\bin)>nul
	
wmic environment create name="CATALINA_HOME",username="<system>",VariableValue="%mytomcatpath%">nul

echo �����������óɹ�
pause