<#
    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.
#>
#region Parameters
[CmdletBinding()]
param (

    # Enter the name of the data set.
    [Parameter(Mandatory)]
    [string]$DataSetName,
    # Enter the path to the source config folder. Assumes child folders or Schemas and Data.
    [Parameter()]
    [string]$ConfigPath,
    # Enter the path to the artifacts folder.  
    [Parameter()]
    [string]$ArtifactPath
)
#endregion
#region Create Paths & Folders
Write-Host "Creating Paths and Folders..."
$_artifactFilePath = $ArtifactPath+"\data\"+$DataSetName+"_data.zip"
$_dataFolderPath = $ConfigPath+"\data\"+$DataSetName+"\"
Write-Debug $_artifactFilePath
Write-Debug $_dataFolderPath
#endregion
if ($DataSetName.ToLower() -eq "none") {
    
    Write-Host "No dataset defined, exiting..."
}
else {

    #region Install PowerShell Tools
    if ($null -eq (Get-Package -Name Xrm.Framework.CI.PowerShell.Cmdlets -ErrorAction SilentlyContinue)) {

        Write-Host "Installing XRM CI Tools..."
        Install-Module -Name Xrm.Framework.CI.PowerShell.Cmdlets -RequiredVersion 9.1.0.1 -Force -WarningAction:SilentlyContinue -InformationAction:SilentlyContinue
    }
    else {

        Write-Host "XRM CI Tools Installed."
    }
    #endregion
    #region Import Data
    Write-Host "Unpack data..."
    Expand-XrmCMData -DataZip $_artifactFilePath -Folder $_dataFolderPath -SplitDataXmlFile $true -SortDataXmlFile $true
    #endregion
}