$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace('.Tests', '')
. "$here\$sut"

Describe 'Test-ReparsePoint' {
    It 'returns false when path is a file' {
        Test-ReparsePoint($FilePath) | Should Be $false
    }

    It 'returns true when path is a symlink' {
        Test-ReparsePoint($RemovableSymLinkPath) | Should Be $true
    }

    It 'returns false when path does not exist' {
        Test-ReparsePoint("$TestDrive\NonExistantPath") | Should Be $false
    }

    BeforeEach {
        # Need Administrator privileges to create the symlinks needed for the tests.
        If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
            [Security.Principal.WindowsBuiltInRole] "Administrator"))
        {
            Write-Warning "You do not have Administrator rights.`nPlease re-run Pester as an Administrator."
            Exit 1
        }

        $FilePath = Setup -Passthru -File '.vimrc' 'set nocompatible'
        $RemovableSymLinkPath = "$TestDrive\symlink"
        $RemovableSymLinkTarget = Setup -Passthru -File ".spf13-vim-3\symlinktarget.txt" 'not spf13-vim'

        # Create a symlink that is visible to cmd.exe in the current
        # directory. $TestDrive isn't accessible from cmd.exe, needed for
        # dealing with symlinks.
        cmd /c mklink $RemovableSymLinkPath $RemovableSymLinkTarget
    }

    AfterEach {
        # Clean up the symlink we created.
        cmd /c del $RemovableSymLinkPath
    }
}
