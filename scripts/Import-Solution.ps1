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
    # Enter the domain suffix of the environment to connect to. Example: For https://contoso.crm.dynamics.com/ the domain name would be crm.dynamics.com.
    [Parameter(Mandatory)]
    [string]$DomainSuffix,
    # If connecting with Service Principle, Enter the Client ID for the Service Principle as a string. Otherwise, leave blank.
    [Parameter(Mandatory)]
    [string]$ClientID,
    # If connecting with Service Principle, Enter the Client Secret for the Service Principle as a string. Otherwise, leave blank.
    [Parameter(Mandatory)]
    [string]$ClientSecret,
    # Enter the Tenant ID for the service principal as a string.
    [Parameter(Mandatory)]
    [string]$TenantID,
    # Enter the name of the solution to import.
    [Parameter(Mandatory)]
    [string]$SolutionName, #
    # Enter the type of solution to work with. Unmanaged | Managed
    [Parameter(Mandatory)]
    [string]$SolutionPackageType,
    # Enter the type of solution import. Update | Upgrade.
    [Parameter(Mandatory)]
    [string]$SolutionImportType, 
    # Enter the source path to the solution source folder. $(System.DefaultWorkingDirectory)/solutionSrc
    [Parameter(Mandatory)]
    [string]$SolutionSourcePath,
    # Enter the path to the artifact folder. $(System.ArtifactsDirectory)
    [Parameter(Mandatory)]
    [string]$ArtifactPath
)
#region Create Zip File Names
$_UnmanagedSolutionZipFileName = $SolutionName+".zip"
$_ManagedSolutionZipFileName = $SolutionName+"_managed.zip"
#endregion
#region Install Power Platform CLI tools
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
#region Create Power Platform CLI Profile
pac auth create --url "https://$DomainName.$DomainSuffix/" --applicationId "$ClientId" --clientSecret "$ClientSecret" --tenant "$TenantId"
#endregion
#region Pack & Import Solution
if ($SolutionPackageType -eq "unmanaged" -or $SolutionPackageType -eq "Unmanaged") {

    Write-Host "Packing Unmanaged Solution..."
    pac solution pack --zipfile $ArtifactPath\Solutions\$_UnmanagedSolutionZipFileName --folder $SolutionSourcePath\$SolutionName --packagetype Unmanaged --allowDelete true --allowWrite true --clobber true --processCanvasApps false
    Write-Host "Prepairing Solution Import..."
    pac solution import --path $ArtifactPath\Solutions\$_UnmanagedSolutionZipFileName --activate-plugins true --force-overwrite true --publish-changes true --async true    
}
elseif ($SolutionPackageType -eq "managed" -or $SolutionPackageType -eq "Managed") {
    
    Write-Host "Packing Managed Solution..."
    pac solution pack --zipfile $ArtifactPath\Solutions\$_ManagedSolutionZipFileName --folder $SolutionSourcePath\$SolutionName --packagetype Managed --allowDelete true --allowWrite true --clobber true --processCanvasApps false

    if ($SolutionImportType -eq "Upgrade" -or $SolutionImportType -eq "upgrade") {
        
        Write-Host "Importing Holding Solution..."
        pac solution import --path $ArtifactPath\Solutions\$_ManagedSolutionZipFileName --activate-plugins true --force-overwrite true --publish-changes true --convert-to-managed true --async true --import-as-holding true
        Write-Host "Upgrading Solution..."
        pac solution upgrade --solution-name $SolutionName --async 
    }
    else {
        
        Write-Host "Importing Solution..."
        pac solution import --path $ArtifactPath\Solutions\$_ManagedSolutionZipFileName --activate-plugins true --force-overwrite true --publish-changes true --convert-to-managed true --async true
    }
}
#endregion
#region Clear Profiles
pac auth clear
#endregion