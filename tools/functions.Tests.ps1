$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace('.Tests', '')
. "$here\$sut"

Describe 'SymLink Functions' {
    # Need to redefine $HOME global variable. Test-SymLinkTargetsSpf13Directory
    # uses it. http://superuser.com/a/82092/
    Remove-Variable -Name HOME -Scope Global -Force
    Set-Variable -Name HOME "$TestDrive"

    Context 'Test-ReparsePoint' {
        It 'returns false when path is a file' {
            Test-ReparsePoint $FilePath | Should Be $false
        }

        It 'returns true when path is a symlink' {
            Test-ReparsePoint $SafeToRemoveSymLinkPath | Should Be $true
        }

        It 'returns false when path does not exist' {
            Test-ReparsePoint "$TestDrive\NonExistentPath" | Should Be $false
        }
    }

    Context 'Test-SymLinkTargetsSpf13Directory' {
        It 'returns true when symlink target is inside spf13-vim-3 directory' {
            Test-SymLinkTargetsSpf13Directory $SafeToRemoveSymLinkPath | Should Be $true
        }

        It 'returns false when symlink target is not inside user directory''s .spf13-vim-3 subdirectory' {
            Test-SymLinkTargetsSpf13Directory $DangerousToRemoveSymLinkPath | Should Be $false
        }

        It 'returns false when symlink is a file' {
            Test-SymLinkTargetsSpf13Directory $FilePath | Should Be $false
        }

        It 'returns false when symlink does not exist' {
            Test-SymLinkTargetsSpf13Directory "$TestDrive\NonExistentPath"
        }
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

        $SafeToRemoveSymLinkPath = "$TestDrive\symlink"
        $SafeToRemoveSymLinkTarget = Setup -Passthru -File ".spf13-vim-3\symlinktarget.txt" 'not spf13-vim'

        $DangerousToRemoveSymLinkPath = "$TestDrive\unsafe-to-remove-symlink"
        $DangerousToRemoveSymLinkTarget = "$TestDrive\non-spf13-vim-3-target"

        cmd /c mklink $SafeToRemoveSymLinkPath $SafeToRemoveSymLinkTarget
        cmd /c mklink $DangerousToRemoveSymLinkPath $DangerousToRemoveSymLinkTarget
    }

    AfterEach {
        # Clean up the symlinks.
        cmd /c del $SafeToRemoveSymLinkPath
        cmd /c del $DangerousToRemoveSymLinkPath
    }
}
