# Uninstall for spf13-vim
$packageName = 'spf13-vim'
$installDir = Join-Path $HOME '.spf13-vim-3'

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$here\functions.ps1"

try {
  Write-Host "Deleting symbolic links"
  # Delete the symbolic links
  Remove-Symlink "$HOME\.vimrc"
  Remove-Symlink "$HOME\_vimrc"
  Remove-Symlink "$HOME\.vimrc.fork"
  Remove-Symlink "$HOME\.vimrc.bundles"
  Remove-Symlink "$HOME\.vimrc.bundles.fork"
  Remove-Symlink "$HOME\.vimrc.before"
  Remove-Symlink "$HOME\.vimrc.before.fork"
  Remove-Symlink "$HOME\.vim"

  Remove-Item -Recurse -Force $installDir
  
  Write-ChocolateySuccess "$packageName"
} catch {
  Write-ChocolateyFailure "$packageName" "$($_.Exception.Message)"
  throw
}
