@echo off

::��ȡ����ԱȨ��
%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0 ::","","runas",1)(window.close)&&exit
::��Ŀ¼�л����ű�����Ŀ¼
cd /d %~dp0

::����war��
call download.bat

set tomcatDir=%CATALINA_HOME%\bin
set rootDir=%CATALINA_HOME%\webapps\ROOT
set zip=C:\Program Files\WinRAR\WinRAR.exe
set name=tomcat_8080

::call %tomcatDir%\shutdown.bat
net stop %name%

::��ʱ5s
choice /t 5 /d y /n >nul


rd /s /Q %rootDir%
md %rootDir%

"%zip%" x -o+ "qsct-local-server.war" "%rootDir%"
ren qsct-local-server.war %date:~,4%%date:~5,2%%date:~8,2%%time:~,2%%time:~3,2%%time:~6,2%.war

::call %tomcatDir%\startup.bat
net start %name%
choice /t 5 /d y /n >nul
tasklist | findstr /i tomcat && echo tomcat�����ɹ� || echo tomcat����ʧ�ܣ���鿴��־
pause