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
    # Enter the Client ID for the Service Principle as a string.
    [Parameter(Mandatory)]
    [string]$ClientID,
    # Enter the Client Secret for the Service Principle as a string.
    [Parameter(Mandatory)]
    [string]$ClientSecret,
    # Enter the Tenant ID for the service principal as a string.
    [Parameter(Mandatory)]
    [string]$TenantID,
    # Enter the name of the solution to export.
    [Parameter(Mandatory)]
    [string]$SolutionName,
    # Enter the new solution version. $(SolutionVersion) from Parse-SolutionVersion.
    [Parameter(Mandatory)]
    [string]$SolutionVersion,
    # Enter the path to the artifact folder. $(System.ArtifactsDirectory) 
    [Parameter(Mandatory)]
    [string]$ArtifactPath,
    # Enter the source path to the solution source folder. $(System.DefaultWorkingDirectory)/solutionSrc 
    [Parameter(Mandatory)]
    [string]$SolutionSourcePath
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
pac auth create --name $DomainName --url "https://$DomainName.$DomainSuffix/" --applicationId "$ClientId" --clientSecret "$ClientSecret" --tenant "$TenantId"
#endregion
#region Set Solution Version
$_SolutionVersion = $SolutionVersion.ToString()
Write-Host "Setting Solution Version..."
pac solution online-version --solution-name $SolutionName --solution-version $_SolutionVersion
#endregion
#region Publish Customizations
pac solution publish --async true
#endregion
#region Export Solution Unmanaged
Write-Host "Export Unmamaned Solution..."
$_Results = pac solution export --path $ArtifactPath\Solutions\$_UnmanagedSolutionZipFileName --name $SolutionName --managed false --include general --async true --overwrite true
for ($i = 0; $i -lt $_Results.Count; $i++) {
    
    if ($_Results[$i].ToLower().StartsWith("error")) {
        
        $_Results[$i]
        $_Results[$i+1]
        for ($j = $i; $j -le $_Results.Count-14; $j++) {
            
            $_Details += $_Results[$j]
        }
        Write-Error $_Details
        break
    }
    elseif ($_Results[$i].ToLower().Contains("succeeded")) {
        
        Write-Host "Solution export succeeded!"
    }
}
#endregion
#region Export Solution Managed
Write-Host "Export Managed Solution..."
$_Results = pac solution export --path $ArtifactPath\Solutions\$_UnmanagedSolutionZipFileName --name $SolutionName --managed true --include general --async true --overwrite true
for ($i = 0; $i -lt $_Results.Count; $i++) {
    
    if ($_Results[$i].ToLower().StartsWith("error")) {
        
        $_Results[$i]
        $_Results[$i+1]
        for ($j = $i; $j -le $_Results.Count-14; $j++) {
            
            $_Details += $_Results[$j]
        }
        Write-Error $_Details
        break
    }
    elseif ($_Results[$i].ToLower().Contains("succeeded")) {
        
        Write-Host "Solution export succeeded!"
    }
}
#endregion
#region Check Solutions
Write-Host "Checking Solution..."
$_Results = pac solution check --path $ArtifactPath\Solutions\$_ManagedSolutionZipFileName --outputDirectory $ArtifactPath\PowerAppsChecker\ --geo UnitedStates
for ($i = 0; $i -lt $_Results.Count; $i++) {
    
    if ($_Results[$i].ToLower().StartsWith("error")) {
        
        $_Results[$i]
        $_Results[$i+1]
        for ($j = $i; $j -le $_Results.Count-14; $j++) {
            
            $_Details += $_Results[$j]
        }
        Write-Error $_Details
        break
    }
    elseif ($_Results[$i].ToLower().Contains("finished")) {
        
        Write-Host "Solution Check succeeded!"
        $_Results[$i+3]
        $_Results[$i+5]
    }
}
#endregion
#region Unpack Solution
$_Results = pac solution unpack --zipfile $ArtifactPath\Solutions\$_UnmanagedSolutionZipFileName --folder $SolutionSourcePath\$SolutionName --packagetype Both --allowDelete true --allowWrite true --clobber true --processCanvasApps true
for ($i = 0; $i -lt $_Results.Count; $i++) {
    
    if ($_Results[$i].ToLower().StartsWith("error")) {
        
        $_Results[$i]
        $_Results[$i+1]
        for ($j = $i; $j -le $_Results.Count-14; $j++) {
            
            $_Details += $_Results[$j]
        }
        Write-Error $_Details
        break
    }
    elseif ($_Results[$i].ToLower().Contains("succeeded")) {
        
        Write-Host "Solution unpack succeeded!"
    }
}
#endregion
#region Clear auth profiles
pac auth clear
#endregion