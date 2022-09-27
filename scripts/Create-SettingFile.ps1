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
[CmdletBinding()]
param (
    # Enter the domain name of the environment to connect to. Example: For https://contoso.crm.dynamics.com/ the domain name would be contoso.
    [Parameter(Mandatory)]
    [string]$DomainName,
    # Enter the name of the solution to create a settings file for.
    [Parameter(Mandatory)]
    [string]$SolutionName,
    # Enter the path to the artifact folder. $(System.ArtifactsDirectory)
    [Parameter(Mandatory)]
    [string]$ArtifactPath,
    # Enter the source path to the source folder. $(System.DefaultWorkingDirectory) - Assumes \config\deployment-settings\generated\ folder structure created
    [Parameter()]
    [string]$SourcePath
)
#region Create Zip File Names
$_ManagedSolutionZipFileName = $SolutionName+"_managed.zip"
$_settingsFilename = $DomainName+".settings."+$SolutionName+".json"
#endregion
#region Install Power Platform CLI tools
Write-Host "Checking Install of Tools..."
if ($null -eq (Get-Package -Name Microsoft.PowerApps.CLI -ErrorAction SilentlyContinue)) {

    Write-Host "Installing Power Platform CLI Tools..."
    Install-Package -Name Microsoft.PowerApps.CLI -Source nuget.org -Force -WarningAction:SilentlyContinue -InformationAction:SilentlyContinue
    $_package = Get-Package -Name Microsoft.PowerApps.CLI
    $_path = ($_package.Source.TrimEnd(($_package.Name+"."+$_package.Version+".nupkg"))+"tools")
    Write-Host "##vso[task.setvariable variable=PacPath]$_path"
    $env:PATH = $env:PATH + ";" + $_path
}
else {

    Write-Host "Power Platform CLI Tools Installed."
    $_package = Get-Package -Name Microsoft.PowerApps.CLI
    $_path = ($_package.Source.TrimEnd(($_package.Name+"."+$_package.Version+".nupkg"))+"tools")
    Write-Host "##vso[task.setvariable variable=PacPath]$_path"
    $env:PATH = $env:PATH + ";" + $_path
}
#endregion
#region enable Telemetry
pac telemetry enable
#endregion
#region Create Settings file
pac solution create-settings -z $ArtifactPath\Solutions\$_ManagedSolutionZipFileName -s $SourcePath\config\deployment-settings\generated\$_settingsFilename
#endregion
#region Clear Profiles
pac auth clear
#endregion