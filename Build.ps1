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
    dotnet add package "Simple Icon File Maker" CommunityToolkit.Mvvm --version 8.2.2    
    dotnet add package "Simple Icon File Maker" CommunityToolkit.WinUI.Helpers --version 8.0.240109
    dotnet add package "Simple Icon File Maker" CommunityToolkit.WinUI.UI.Animations --version 7.1.2 
    dotnet add package "Simple Icon File Maker" Magick.NET-Q16-AnyCPU --version 13.10.0 
    dotnet add package "Simple Icon File Maker" Microsoft.Extensions.Hosting --version 8.0.0 
    dotnet add package "Simple Icon File Maker" Microsoft.WindowsAppSDK --version 1.5.240627000 
    dotnet add package "Simple Icon File Maker" Microsoft.Windows.SDK.BuildTools --version 10.0.26100.1 
    dotnet add package "Simple Icon File Maker" PropertyChanged.Fody --version 4.1.0 
    dotnet add package "Simple Icon File Maker" WinUIEx --version 2.3.4 
    dotnet publish $csproj.FullName -c Release -f net8.0 -r win-x64 --artifacts-path $OutputDirectory -p:PublishTrimmed=true -p:PublishReadyToRun=false
}

Compress-Archive -Path ${Get-ChildItem -Recurse -Path $OutputDirectory} -DestinationPath $OutputDirectory\client-win-x64.zip
& gh release create v1.0 $OutputDirectory\client-win-x64.zip
