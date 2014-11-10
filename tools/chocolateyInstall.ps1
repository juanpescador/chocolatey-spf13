﻿$packageName = 'spf13-vim'
$spfUrl = 'https://github.com/spf13/spf13-vim/raw/3.0/spf13-vim-windows-install.cmd'
$silentArgs = '/S' 
$exeToRun = 'cmd.exe'
$validExitCodes = @(0,1) 

# Download and install spf13
try { 
  $scriptPath = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
  $cmdPath = Join-Path $scriptPath 'spf13-vim-windows-install.cmd'

  Get-ChocolateyWebFile "$packageName" "$cmdPath" "$spfUrl"
  #Start-ChocolateyProcessAsAdmin $cmdPath $exeToRun -validExitCodes $validExitCodes
  Start-ChocolateyProcessAsAdmin "/c $cmdPath" $exeToRun
  Write-ChocolateySuccess "$packageName"
} catch {
  Write-ChocolateyFailure "$packageName" "$($_.Exception.Message)"
  throw
}