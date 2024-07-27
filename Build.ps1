$OutputDirectory ="$PSScriptRoot\rel"

If (Test-Path $OutputDirectory)
{
    Remove-Item $OutputDirectory -Recurse -$Force
}
Else
{
    New-Item -Path $OutputDirectory -ItemType "directory"
}

foreach ($csproj in $(Get-ChildItem -Recurse $PSScriptRoot -Filter *.csproj))
{
    dotnet restore
    dotnet publish $csproj.FullName -c Release -f net8.0 -r win-x64 --artifacts-path $OutputDirectory -p:PublishSingleFile=true -p:PublishTrimmed=true -p:PublishReadyToRun=false
}

Get-ChildItem -Recurse -Path $OutputDirectory | Compress-Archive -Recurse $OutputDirectory\client-win-x64.zip
& gh release create v1.0 $OutputDirectory\client-win-x64.zip
