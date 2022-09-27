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
    # Enter the TenantID of the Organization to connect to.
    [Parameter(Mandatory)]
    [string]$TenantId,
    # Enter the id of the web sit (portal). Obtained through 'pac paportal list' command.
    [Parameter(Mandatory)]
    [string]$WebsiteId,
    # Enter the source path to the source folder. Assumes child folders or Schemas and Data.
    [Parameter()]
    [string]$SourcePath
)
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
#region Download Portal
$_Results = pac paportal download --path $SourcePath --webSiteId $WebsiteId --overwrite true 
for ($i = 0; $i -lt $_Results.Count; $i++) {
        
    if ($_Results[$i].ToLower().StartsWith("error")) {
        
        $_Results[$i]
        $_Results[$i+1]
        for ($j = $i; $j -le $_Results.Count; $j++) {
            
            $_Details += $_Results[$j]
        }
        Write-Error $_Details
        break
    }
    elseif ($_Results[$i].ToLower().Contains("succeeded")) {
        
        Write-Host "Portal download succeeded!"
    }
}
#endregion
#region Clear Profiles
pac auth clear
#endregion