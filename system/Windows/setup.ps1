# Run this line manually beforehand to allow this script to run, which will
# elevate itself then handle the rest.
# Set-ExecutionPolicy -scope currentuser Unrestricted -Force
#
# To be run from administrative shell
##Requires -RunAsAdministrator
Set-ExecutionPolicy Unrestricted -Force
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

# $scriptpath = $MyInvocation.MyCommand.Path
# $scriptdir = Split-Path $scriptpath
$scriptdir = $PSScriptRoot
cd $scriptdir
[Environment]::CurrentDirectory = $PWD

# Install chocolatey
if(-not(powershell choco -v)){
    Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}
if(-not(powershell Boxstarter -v)){
    cup Boxstarter -y
}
choco feature enable -n=allowGlobalConfirmation

Import-Module Boxstarter.Chocolatey
$Boxstarter.RebootOk=$true
$Boxstarter.NoPassword=$false
$Boxstarter.AutoLogin=$true
$cred=Get-Credential domain\username
Install-BoxstarterPackage -PackageName "$scriptdir\boxstarter-main.ps1" -Credential $cred
