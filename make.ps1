Param(
    [Parameter(Position=0, Mandatory=$true, HelpMessage="Enter the action to take, e.g. libs, configure, build, clean, cleanlibs.")]
    [String]
    $Command,

    [Parameter(HelpMessage="The build configuration (Release, Debug, RelWithDebInfo, MinSizeRel).")]
    [String]
    $Config = "Release"
)

$ErrorActionPreference = "Stop"

# Sanitize config to conform to CMake build configs.
switch ($Config.ToLower())
{
    "release" { $Config = "Release"; break; }
    "debug" { $Config = "Debug"; break; }
    "relwithdebinfo" { $Config = "RelWithDebInfo"; break; }
    "minsizerel" { $Config = "MinSizeRel"; break; }
    default { throw "'$Config' is not a valid config; use Release, Debug, RelWithDebInfo, or MinSizeRel)." }
}

Write-Output "make.ps1 $Command -Config $Config"

$srcDir = Split-Path $script:MyInvocation.MyCommand.Path
$buildDir = Join-Path -Path $srcDir -ChildPath "build"
$libsDir = Join-Path -Path $buildDir -ChildPath "libs"
$outDir = Join-Path -Path $buildDir -ChildPath $Config

Write-Output "Source directory: $srcDir"
Write-Output "Build directory:  $buildDir"
Write-Output "Libs directory:   $libsDir"
Write-Output "Output directory: $outDir"

if (($Command.ToLower() -ne "libs") -and !(Test-Path -Path $libsDir))
{
    throw "Libs directory '$libsDir' does not exist; you may need to run 'make.ps1 libs' first."
}

switch ($Command.ToLower())
{
    "libs"
    {
        if (!(Test-Path -Path $libsDir))
        {
            New-Item -ItemType "directory" -Path $libsDir
        }

        $libsBuildDir = Join-Path -Path $libsDir -ChildPath "build"
        if (!(Test-Path -Path $libsBuildDir))
        {
            New-Item -ItemType "directory" -Path $libsBuildDir
        }

        $libsSrcDir = Join-Path -Path $srcDir -ChildPath "lib"
        Write-Output "Configuring libraries..."
        Write-Output "cmake.exe -B $libsBuildDir -S $libsSrcDir -DCMAKE_INSTALL_PREFIX=$libsDir -DCMAKE_BUILD_TYPE=Release -DCMAKE_GENERATOR_PLATFORM=x64 -Thost=x64"
        & cmake.exe -B $libsBuildDir -S $libsSrcDir -DCMAKE_INSTALL_PREFIX="$libsDir" -DCMAKE_BUILD_TYPE=Release -DCMAKE_GENERATOR_PLATFORM=x64 -Thost=x64
        if ($LastExitCode -ne 0) { throw "Error!" }

        Write-Output "Building libraries..."
        Write-Output "cmake.exe --build $libsBuildDir --target install --config Release"
        & cmake.exe --build $libsBuildDir --target install --config Release
        if ($LastExitCode -ne 0) { throw "Error!" }

        break
    }
    "cleanlibs"
    {
        if (Test-Path -Path $libsDir)
        {
            Write-Output "Removing $libsDir..."
            Remove-Item -Path $libsDir -Recurse
        }

        break
    }
    "configure"
    {
        Write-Output "cmake.exe -B $buildDir -S $srcDir -DCMAKE_BUILD_TYPE=$Config -DCMAKE_GENERATOR_PLATFORM=x64 -Thost=x64"
        & cmake.exe -B $buildDir -S $srcDir -DCMAKE_BUILD_TYPE="$Config" -DCMAKE_GENERATOR_PLATFORM=x64 -Thost=x64
        if ($LastExitCode -ne 0) { throw "Error!" }

        break
    }
}
