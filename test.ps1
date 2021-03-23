Invoke-Command -Computer JayRDC -Authentication Kerberos -Scriptblock{Get-Date|out-file -filepath C:\DBA\CurrentDate.txt}
