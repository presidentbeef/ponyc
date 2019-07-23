$ErrorActionPreference = "Stop"

Set-Location C:\projects\ponyc
& C:\projects\ponyc\make.ps1 test -Config $env:configuration
