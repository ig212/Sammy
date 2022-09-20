#ms is the link to obtain the latest service-packs for 2016
$ms='https://support.microsoft.com/en-us/topic/kb3177534-how-to-obtain-the-latest-service-pack-for-sql-server-2016-8dea89cc-c50b-dccd-374b-9933e960ab52'
$ms2=(Invoke-WebRequest -UseBasicParsing -Uri $ms -Verbose).links.href|?{$_ -like 'https://www.microsoft.com/download/details.aspx?FamilyID=*'}|Select -First 1
 
#link for the latest cumulative update

$sp="https://support.microsoft.com/en-us/topic/kb3177312-sql-server-2016-build-versions-d6cd8e5f-4aa3-20ac-f38f-8faef950840f"
$sp2=(Invoke-WebRequest -UseBasicParsing -Uri $sp).links.href|?{$_ -like '/en-us/topic*'}|select -First 1
$new_sp2="https://support.microsoft.com"+ $sp2

(invoke-webrequest -usebasicparsing -uri $new_sp2 -verbose).links.href

# https://support.microsoft.com/en-us/topic/kb5015371-description-of-the-security-update-for-sql-server-2016-sp3-azure-connect-feature-pack-june-14-2022-d809657e-15a9-48fe-bd19-a8864ac5d3a4


$jn="http://www.catalog.update.microsoft.com/Search.aspx?q=KB5015371"

(Invoke-WebRequest -UseBasicParsing -Uri $jn -Verbose).links.href
