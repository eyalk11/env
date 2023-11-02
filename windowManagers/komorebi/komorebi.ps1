# By default, komorebi will start up $Env:UserProfile\komorebi.ahk if it exists.
# $Env:KOMOREBI_AHK_V1="$(where autohotkey)"
$logFile="$env:UserProfile/.logs/komorebi.log"
try {
    Stop-Transcript | out-null
} catch {}
Start-Transcript -path $logFile -force

komorebic start --await-configuration

# Enable hot reloading of changes to ~/komorebi.ahk
# komorebic watch-configuration "enable"

. "$PSScriptRoot\settings.ps1"

# Leave till last
start-process -WindowStyle hidden autohotkey `
    -ArgumentList "$PSScriptRoot\komorebi.ahk"

komorebic complete-configuration

sleep 5

# For some reason this isn't working when sourcing it after settings, so let's try sourcing it after
# configuration completes...
# source the generated Crowd-sourced app configs.
# Source in powershell because autokey's run is quite slow.
. "~\.config\komorebi\komorebi.generated.ps1"

Stop-Transcript
