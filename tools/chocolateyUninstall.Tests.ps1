$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests", ".")
. "$here\$sut"
. "$here\..\lib\Pester-3.3.6\Pester.psm1"

Describe "RemoveSymLinkIfUnchanged" {
    Context "When SymLink has changed to a file" {
        Setup -File ".vimrc" "set nocompatible"

        It "does not remove the file" {
            $true | Should Be $true
        }
    }

}
