Push-Location

Set-Location "$PSScriptRoot\..\AANM"

.$PSScriptRoot\hemtt armake build --force -i include "$PSScriptRoot\..\AANM" "$PSScriptRoot\..\AANM.pbo" -w unquoted-string -w redefinition-wo-undef -w excessive-concatenation
.$PSScriptRoot\DSCreateKey 'aanm'
.$PSScriptRoot\DSSignFile 'aanm.biprivatekey' "$PSScriptRoot\..\AANM.pbo"

$versionFile = Get-ChildItem -Path "$PSScriptRoot\..\AANM\keys" -Name
$version = $versionFile.Substring(4)

Remove-Item "$PSScriptRoot\..\AANM\keys\ace_*"
Copy-Item 'aanm.bikey' -Destination "keys\aanm_$version"

Pop-Location

Pop-Location

Pop-Location
