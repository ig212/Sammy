Invoke-Command -Computer JayRDC -Scriptblock{Get-Date|out-file -filepath C:\DBA\CurrentDate.txt}
