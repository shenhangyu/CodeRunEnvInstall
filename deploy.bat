@echo off

::获取管理员权限
%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0 ::","","runas",1)(window.close)&&exit
::将目录切换到脚本所在目录
cd /d %~dp0

::下载war包
call download.bat

set tomcatDir=%CATALINA_HOME%\bin
set rootDir=%CATALINA_HOME%\webapps\ROOT
set zip=C:\Program Files\WinRAR\WinRAR.exe
set name=tomcat_8080

::call %tomcatDir%\shutdown.bat
net stop %name%

::延时5s
choice /t 5 /d y /n >nul


rd /s /Q %rootDir%
md %rootDir%

"%zip%" x -o+ "qsct-local-server.war" "%rootDir%"
ren qsct-local-server.war %date:~,4%%date:~5,2%%date:~8,2%%time:~,2%%time:~3,2%%time:~6,2%.war

::call %tomcatDir%\startup.bat
net start %name%
choice /t 5 /d y /n >nul
tasklist | findstr /i tomcat && echo tomcat启动成功 || echo tomcat启动失败，请查看日志
pause