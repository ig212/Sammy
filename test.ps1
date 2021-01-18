Invoke-Command -Computer JAYPRD01 -Scriptblock{Get-Date|out-file -filepath C:\DBA\CurrentDate.txt}
