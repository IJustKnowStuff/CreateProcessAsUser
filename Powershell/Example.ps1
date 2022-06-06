
<## Example commands to use this function.  Example collects information from logged on users certificate store and saves it to a text file. ##>

$OutputFile = "C:\Temp\UserCertificates.txt"

[string[]]$UserParams="Write-Host 'Running script. Please wait......'"

$UserParams+='Write-Output \"Collecting information for logged on user: $($env:USERNAME)\" | out-file \"' + $OutputFile + '\" -Append'

$UserParams+='Write-Output \"=============================`n= List User Certificates`n=============================\" | out-file \"' + $OutputFile + '\" -Append'

$UserParams+='Get-ChildItem Cert:\CurrentUser\my | select Thumbprint,Subject,FriendlyName,NotBefore,NotAfter,@{N=\"Template\";E={($_.Extensions | where-object{$_.oid.Friendlyname -match \"Certificate Template Information\"}).Format(0) -replace \"(.+)?=(.+)\((.+)?\", \"$2\"}},@{N=\"EKU\";E={$_.EnhancedKeyUsageList -join \";\"}},@{N=\"SubjectAlternativeName\";E={try{(($_.Extensions | Where-Object {$_.Oid.FriendlyName -match \"subject alternative name\"}).format(0) | %{($_.split(\",\") | where{$_ -match \"DNS Name\"})}) -join \";\"  }catch{}}} | fl | out-file \"' + $OutputFile + '\" -Append'
   
$UserParams+='Write-Output \"[Completed User Information]\" | out-file \"' + $OutputFile + '\" -Append'

RunAsLoggedOnUser -Program "c:\windows\system32\WindowsPowerShell\v1.0\powershell.exe" -Params ($UserParams -join ";")

#Load Notepad as the logged on user.
RunAsLoggedOnUser -Program "c:\windows\notepad.exe" -Params "'$OutputFile'"
