function Plugin($module) {
    try {
      Import-Module $module -ErrorAction Stop
    } catch [System.IO.FileNotFoundException] {
      Install-Module $module -AllowClobber -Scope CurrentUser
    }
}

Plugin ZLocation  # Also provides startup time info.
Plugin PSReadline  # Included by default after v3.

Plugin GuiCompletion
Install-GuiCompletion -Key Tab
Plugin TabExpansionPlusPlus  # A little heavy.
# Plugin PSUtil  # Hurts startup time a lot

# Coloured LS output
Plugin Get-ChildItemColor
If (-Not (Test-Path Variable:PSise)) {  # Only run this in the console and not in the ISE
    Set-Alias l Get-ChildItem -option AllScope
    Set-Alias ls Get-ChildItemColorFormatWide -option AllScope
    $Global:GetChildItemColorVerticalSpace = 1 # Powershell default is 2.
}

Plugin posh-git
Plugin oh-my-posh
Set-Theme Agnoster

