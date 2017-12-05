@echo off & title 下载war包

::设置要下载的文件链接，仅支持http协议。必写项。
set Url=

::设置文件保存目录，若下载至当前目录，请留空
set Save=%~dp0

for %%a in ("%Url%") do set "FileName=%%~nxa"
if not defined Save set "Save=%cd%"
(echo Download Wscript.Arguments^(0^),Wscript.Arguments^(1^)
echo Sub Download^(url,target^)
echo   Const adTypeBinary = 1
echo   Const adSaveCreateOverWrite = 2
echo   Dim http,ado
echo   Set http = CreateObject^("Msxml2.ServerXMLHTTP"^)
echo   http.open "GET",url,False
echo   http.send
echo   Set ado = createobject^("Adodb.Stream"^)
echo   ado.Type = adTypeBinary
echo   ado.Open
echo   ado.Write http.responseBody
echo   ado.SaveToFile target
echo   ado.Close
echo End Sub)>DownloadFile.vbs

DownloadFile.vbs "%Url%" "%Save%\%FileName%"
del DownloadFile.vbs