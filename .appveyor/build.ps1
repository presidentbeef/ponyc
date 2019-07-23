$ErrorActionPreference = "Stop"

Set-Location C:\projects\ponyc

if (!(Test-Path "C:\projects\ponyc\build\libs\bin\llc.exe"))
{
  & git submodule update --init --recursive
  & C:\projects\ponyc\make.ps1 libs
}

$package_commit = git rev-parse --short --verify "HEAD^{commit}"
$package_version = (Get-Content "VERSION")
$package_iteration = "$package_iteration${env:appveyor_build_number}.$package_commit"
Update-AppveyorBuild -Version "ponyc-$package_version-$package_iteration"

& C:\projects\ponyc\make.ps1 configure -Config $eng:configuration
& C:\projects\ponyc\make.ps1 build -Config $env:configuration

$ponydir = "ponyc-${package_version}-win64-$env:configuration"
MkDir "$ponydir"
MkDir "${ponydir}\ponyc"
MkDir "${ponydir}\ponyc\bin"
$builddir = "C:\projects\ponyc\build\${env:configuration}"

Copy-Item $builddir\ponyc.* "${ponydir}\ponyc\bin"
Copy-Item $builddir\libponyc.* "${ponydir}\ponyc\bin"
Copy-Item $builddir\libponyrt.* "${ponydir}\ponyc\bin"
Copy-Item $builddir\*.lib "${ponydir}\ponyc\bin"
Copy-Item-Recurse packages "${ponydir}\packages"
7z a -tzip "C:\projects\ponyc\${ponydir}.zip" "${ponydir}"
