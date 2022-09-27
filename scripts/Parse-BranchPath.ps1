<#
    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.
#>
[CmdletBinding()]
param (
    # Enter the build variable $(Build.SourceBranchName)
    [Parameter(Mandatory)]
    [string]$BranchPath
)
$BranchPath
$_BranchPathArray = $BranchPath.ToCharArray()
$_backwards = $null
for ($i = $_BranchPathArray.Count-1; $i -gt -1; $i--) {

    if ($_BranchPathArray[$i] -eq "/") {
       
        break
    }
    else {
        
        $_backwards += $_BranchPathArray[$i]
    }
}
$_backwards = $_backwards.ToCharArray()
$_forwards = $null
for ($i = $_backwards.Count-1; $i -gt -1; $i--) {
    
    $_forwards += $_backwards[$i]
}
$_forwards
Write-Host "##vso[task.setvariable variable=SolutionName]$_forwards"
Write-Host "##vso[task.setvariable variable=PortalName]$_forwards"