@echo off

set ROOT_DIR=%~dp0

where cmake > nul
if errorlevel 1 goto nocmake

set GOTOLIBS=false
if "%1"=="libs" (
  set GOTOLIBS=true
  shift
)

set GOTOCONFIG=false
if "%1"=="configure" (
  set GOTOCONFIG=true
  shift
)

set GOTOCLEAN=false
if "%1"=="clean" (
  set GOTOCLEAN=true
  shift
)

set GOTOCLEANLIBS=false
if "%1"=="cleanlibs" (
  set GOTOCLEANLIBS=true
  shift
)

set GOTODISTCLEAN=false
if "%1"=="distclean" (
  set GOTODISTCLEAN=true
  shift
)

set GOTOTEST=false
if "%1"=="test" (
  set GOTOTEST=true
  shift
)

set GOTODOCS=false
if "%1"=="docs" (
  set GOTODOCS=true
  shift
)

set CONFIG=Release
if "%1"=="config" (
  set CONFIG=%2
  shift
  shift
)

set LIBS_CONFIG=Release
if "%1"=="libs_config" (
  set LIBS_CONFIG=%2
  shift
  shift
)

set CMAKE_GEN=
if "%1"=="gen" (
  set CMAKE_GEN="-G %2"
  shift
  shift
)

set CMAKE_INSTALL_PREFIX=
if "%1"=="cmake_install_prefix" (
  set CMAKE_INSTALL_PREFIX="-DCMAKE_INSTALL_PREFIX=%1"
  shift
  shift
)

set BUILD_DIR=%ROOT_DIR%build\%CONFIG%
echo BUILD_DIR=%BUILD_DIR%
set LIBS_DIR=%ROOT_DIR%build\libs\%CONFIG%
echo LIBS_DIR=%LIBS_DIR%

if "%GOTOCLEAN%"=="true" goto clean
if "%GOTOCLEANLIBS%"=="true" goto cleanlibs
if "%GOTODISTCLEAN%"=="true" goto distclean
if "%GOTOLIBS%"=="true" goto libs

if not exist "%LIBS_DIR%" (
  echo Cannot find "%LIBS_DIR%", you may need to run ".\make.bat libs --config=%CONFIG%"
  goto error
)

if "%GOTOCONFIG%"=="true" goto config
if "%GOTOTEST%"=="true" goto test
if "%GOTODOCS%"=="true" goto docs

:build
echo make.bat build --config=%CONFIG%
if not exist "%BUILD_DIR%" (
  echo mkdir "%BUILD_DIR%"
  mkdir "%BUILD_DIR%"
  if errorlevel 1 goto error
)
echo pushd %BUILD_DIR%
pushd %BUILD_DIR%
echo cmake --build %BUILD_DIR% --target ALL_BUILD --config %CONFIG%
cmake --build %BUILD_DIR% --target ALL_BUILD --config %CONFIG%
if errorlevel 1 goto error
goto done

:config
echo make.bat config --config=%CONFIG%
if not exist "%BUILD_DIR%" (
  echo mkdir "%BUILD_DIR%"
  mkdir "%BUILD_DIR%"
  if errorlevel 1 goto error
)
echo pushd "%BUILD_DIR%"
pushd "%BUILD_DIR%"
if errorlevel 1 goto error
echo cmake %ROOT_DIR% %CMAKE_GEN% %CMAKE_INSTALL_PREFIX% -DCMAKE_BUILD_TYPE=%CONFIG% -DCMAKE_GENERATOR_PLATFORM=x64 -Thost=x64
cmake %ROOT_DIR% %CMAKE_GEN% %CMAKE_INSTALL_PREFIX% -DCMAKE_BUILD_TYPE=%CONFIG% -DCMAKE_GENERATOR_PLATFORM=x64 -Thost=x64
goto done

:clean
echo make.bat clean --config=%CONFIG%
pushd "%ROOT_DIR%"
if exist "%BUILD_DIR%" (
  echo rmdir /s /q "%BUILD_DIR%"
  rmdir /s /q "%BUILD_DIR%"
  if errorlevel 1 goto error
)
goto done

:cleanlibs
echo make.bat clean --config=%CONFIG%
pushd "%ROOT_DIR%"
if exist "%LIBS_DIR%" (
  echo rmdir /s /q "%LIBS_DIR%"
  rmdir /s /q "%LIBS_DIR%"
  if errorlevel 1 goto error
)
goto done

:distclean
echo make.bat distclean --config=%CONFIG%
pushd "%ROOT_DIR%"
goto done

:test
echo make.bat test --config=%CONFIG%
goto done

:docs
echo make.bat docs --config=%CONFIG%
goto done

:libs
echo make.bat libs --config=%LIBS_CONFIG% %CMAKE_GEN%
if not exist "%LIBS_DIR%\build" mkdir "%LIBS_DIR%\build"
if errorlevel 1 goto error
echo pushd "%LIBS_DIR%\build"
pushd "%LIBS_DIR%\build"
echo cmake "%ROOT_DIR%lib" %CMAKE_GEN% -DCMAKE_INSTALL_PREFIX="%LIBS_DIR%" -DCMAKE_BUILD_TYPE=%LIBS_CONFIG% -DCMAKE_GENERATOR_PLATFORM=x64 -Thost=x64
cmake "%ROOT_DIR%lib" %CMAKE_GEN% -DCMAKE_INSTALL_PREFIX="%LIBS_DIR%" -DCMAKE_BUILD_TYPE=%LIBS_CONFIG% -DCMAKE_GENERATOR_PLATFORM=x64 -Thost=x64
if errorlevel 1 goto error
echo cmake --build "%LIBS_DIR%\build" --target install --config %LIBS_CONFIG%
cmake --build "%LIBS_DIR%\build" --target install --config %LIBS_CONFIG%
if errorlevel 1 goto error
goto done

:nocmake
echo You must have CMake.exe in your PATH.
goto error

:error
popd
echo Error detected; exiting!
%COMSPEC% /c exit 1

:done
popd
