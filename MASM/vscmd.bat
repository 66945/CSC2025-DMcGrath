@echo off
:: %comspec% /k "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars32.bat"

:: call x86 %*

:: ----------------------------------------
:parse_args

:: WARN: these don't do anything - find the actual path
set __VCVARSALL_STORE=
set __VCVARSALL_WINSDK=
set __VCVARSALL_PARSE_ERROR=
set __VCVARSALL_TARGET_ARCH=
set __VCVARSALL_HOST_ARCH=
set __VCVARSALL_VER=


:: TODO: build __VCVARSALL_TARGET_ARCH, __VCVARSALL_HOST_ARCH

set __VCVARSALL_TARGET_ARCH=x86
set __VCVARSALL_HOST_ARCH=x86
set __local_ARG_FOUND=1

set "__VSVARSALL_VSDEVCMD_ARGS=-arch=x86 -host_arch=x86"
set VSCMD_VCVARSALL_INIT=1

:: WARN: no /clean_env

:: vsdevcmd call
:: call "%~dp0..\..\..\Common7\Tools\vsdevcmd.bat -arch=x86 -host_arch=x86"
:: TODO: unpack

:: I hate this actually
call "%~dp0vsdevcmd\core\vsdevcmd_start.bat"
set __VSCMD_ARGS_LIST=

:: IMPORTANT:
set "VisualStudioVersion=17.6"
set "VSCMD_VER=17.6"

:: TODO: figure out correct vscmd_ver + print header for fun
call :get_vscmd_ver

:: TODO: unpack all

:: core

@REM *** .NET Framework ***
:core_dotnet
if EXIST "%VS170COMNTOOLS%VsDevCmd\core\dotnet.bat" call :call_script_helper core\dotnet.bat

@REM *** msbuild ***
:core_msbuild
if EXIST "%VS170COMNTOOLS%VsDevCmd\core\msbuild.bat" call :call_script_helper core\msbuild.bat

@REM *** Windows SDK ***
:core_winsdk
if EXIST "%VS170COMNTOOLS%VsDevCmd\core\winsdk.bat" call :call_script_helper core\winsdk.bat

:: ext

@REM Iterate through ext scripts
if NOT EXIST "%VS170COMNTOOLS%vsdevcmd\ext\" (
    @echo [ERROR:%~nx0] Cannot find 'ext' folder "%VS170COMNTOOLS%vsdevcmd\ext\"
    set /A __vscmd_vsdevcmd_errcount=__vscmd_vsdevcmd_errcount+1
    goto :ext_end
)

for /F %%a in ( 'dir "%VS170COMNTOOLS%vsdevcmd\ext\*.bat" /b /a-d-h /on' ) do (
    call :call_script_helper ext\%%a
)

:ext_end
set __vscmd_dir_cmd_opt=



:: TODO: check for errors

:end
:: cleanup variables
set __VCVARSALL_TARGET_ARCH=
set __VCVARSALL_HOST_ARCH=
set __VCVARSALL_STORE=
set __VCVARSALL_WINSDK=
set __VCVARSALL_PARSE_ERROR=
set __VCVARSALL_CLEAN_ENV=
set VSCMD_VCVARSALL_INIT=
set __VCVARSALL_VSDEVCMD_ARGS=
set __VCVARSALL_HELP=
set __VCVARSALL_VER=
set __VCVARSALL_SPECTRE=
