Invoke-Command -Computer JJayRDC -Scriptblock{Get-Date|out-file -filepath C:\DBA\CurrentDate.txt}
