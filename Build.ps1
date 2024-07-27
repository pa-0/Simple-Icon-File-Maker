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
    dotnet add "Simple Icon File Maker" package CommunityToolkit.Mvvm --version 8.2.2    
    dotnet add "Simple Icon File Maker" package CommunityToolkit.WinUI.Helpers --version 8.0.240109
    dotnet add "Simple Icon File Maker" package CommunityToolkit.WinUI.UI.Animations --version 7.1.2 
    dotnet add "Simple Icon File Maker" package Magick.NET-Q16-AnyCPU --version 13.10.0 
    dotnet add "Simple Icon File Maker" package Microsoft.Extensions.Hosting --version 8.0.0 
    dotnet add "Simple Icon File Maker" package Microsoft.WindowsAppSDK --version 1.5.240627000 
    dotnet add "Simple Icon File Maker" package Microsoft.Windows.SDK.BuildTools --version 10.0.26100.1 
    dotnet add "Simple Icon File Maker" package PropertyChanged.Fody --version 4.1.0 
    dotnet add "Simple Icon File Maker" package WinUIEx --version 2.3.4 
    dotnet publish $csproj.FullName -c Release -r win-x64 --artifacts-path $OutputDirectory -p:PublishTrimmed=true -p:PublishReadyToRun=false
}

Compress-Archive -Path $OutputDirectory -DestinationPath $OutputDirectory\client-win-x64.zip
& gh release create v1.0 $OutputDirectory\client-win-x64.zip
