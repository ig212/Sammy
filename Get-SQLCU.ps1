function Get-SqlCU{ [cmdletbinding()] param(
  [Parameter(Mandatory)][Validateset(2016, 2017,2019)][int]$version
)
try{

    if
    (  $version -isnot [int]) {write-error "Integer not entered";write-output $Error[0]}
    
    else
    {
      if
      ( $version -eq 2017)
      {
        $sql_2017_dl="https://www.microsoft.com/en-us/download/confirmation.aspx?id=56128"
        # this link will always be for the latest release of sql 2017 updates
        $Invoke_CU= (Invoke-WebRequest -UseBasicParsing -Uri $sql_2017_dl -Method Get -Verbose).links.href|?{$_ -like "https://download.microsoft.com/download/C/4*"}| Select -First 1
        $Retrieve_CU_KB_Name= $Invoke_CU.Substring(83,31)
        $Folder_Name=$Retrieve_CU_KB_Name.Substring(14,9)
        $path="C:\Sammy\sql2017\$Folder_Name"
         if((Test-Path -Path $path) -eq $false)
              { New-Item -ItemType Directory -Path $path -Verbose;
                $Download_2017Update= Invoke-WebRequest -UseBasicParsing -Uri $Invoke_CU -Method Get -OutFile $path\$Retrieve_CU_KB_Name -Verbose}
         else{
               if
              (   ((get-childitem -Path $path).Name) -eq $Retrieve_CU_KB_Name){write-host "KB exists in folder"}
               else
               {
                  $Download_2017Update= Invoke-WebRequest -UseBasicParsing -Uri $Invoke_CU -Method Get -OutFile $path\$Retrieve_CU_KB_Name -Verbose
               # Verify that the KB was successfully downloaded to the path 
               if
               (   ((Get-Childitem -Path $path).Name) -eq $Retrieve_CU_KB_Name
               )
               {Write-Output "$Retrieve_CU_KB_Name was successfully downloaded to $path "
               }
               else
               {
                 Write-Output "$Retrieve_CU_KB_Name to $path was not successfully. Retry!"
               }
               }

            }
      }
          
      if
      ( $version -eq 2019)
      {
        $sql_2019_dl="https://www.microsoft.com/en-us/download/confirmation.aspx?id=100809"
        # this link will always be for the latest release of sql 2019 updates
        $Invoke_CU= (Invoke-WebRequest -UseBasicParsing -Uri $sql_2019_dl -Method Get -Verbose).links.href|?{$_ -like "https://download.microsoft.com/download/6/e*"}| Select -First 1
        $Retrieve_CU_KB_Name= $Invoke_CU.Substring(83,31)
        $Folder_Name=$Retrieve_CU_KB_Name.Substring(14,9)
        $path="C:\Sammy\sql2019\$Folder_Name"
          if
          ( (Test-Path -Path $path) -eq $false
          )
          { New-Item -ItemType Directory -Path $path -Verbose;
            $Download_2019Update= Invoke-WebRequest -UseBasicParsing -Uri $Invoke_CU -Method Get -OutFile $path\$Retrieve_CU_KB_Name\$Retrieve_CU_KB_Name -Verbose
          }
          else
          {
            if
              (   ((Get-Childitem -Path $path).Name) -eq $Retrieve_CU_KB_Name){write-host "KB exists in folder"}
              else
              {
                 $Download_2019Update= Invoke-WebRequest -UseBasicParsing -Uri $Invoke_CU -Method Get -OutFile $path\$Retrieve_CU_KB_Name -Verbose
              }
              # Verify that the KB was successfully downloaded to the path 
              if
              (   ((Get-Childitem -Path $path).Name) -eq $Retrieve_CU_KB_Name
              )
              {Write-Output "$Retrieve_CU_KB_Name was successfully downloaded to $path "
              }
              else
              {
                Write-Output "$Retrieve_CU_KB_Name to $path was not successfully. Retry!"
              }
          }
      }
      elseif
      (
        $version -eq  2016
      )
      {
         Write-Output "sql $version is currently unsupported. "
      }

  

    } 


}


catch
{
    Write-Warning $Error[0]
}

}
