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
    # Enter the domain name of the environment to connect to. Example: For https://contoso.crm.dynamics.com/ the domain name would be contoso.
    [Parameter(Mandatory)]
    [string]$DomainName,
    # If connecting with Service Principle, Enter the Client ID for the Service Principle as a string.
    [Parameter(Mandatory)]
    [string]$ClientID,
    # If connecting with Service Principle, Enter the Client Secret for the Service Principle as a string.
    [Parameter(Mandatory)]
    [string]$ClientSecret,
    # Enter the TenantID of the Organization to connect to.
    [Parameter(Mandatory)]
    [string]$TenantId,
    # Enter the prefix used for the canvas apps (non-model-driven) that you want to share with the environment. Note, data permissions are still required. For cont_ContosoApp_469s0 it would be cont.
    [Parameter(Mandatory)]
    [string]$PublisherPrefix,
    # Enter the Permission leve desired to give the Canvas App. CanViewWithShare | CanEdit | CanView.
    [Parameter(Mandatory)]
    [string]$Permissions
)
#region Install Power Apps Administration Module
Write-Host "Checking Install of Tools..."
if ($null -eq (Get-Package -Name Microsoft.PowerApps.Administration.PowerShell -ErrorAction SilentlyContinue)) {

    Write-Host "Installing Power Platform Admin Tools..."
    Install-Module -Name Microsoft.PowerApps.Administration.PowerShell -Force -WarningAction:SilentlyContinue -InformationAction:SilentlyContinue
}   
else {
    
    Write-Host "Power Platform Admin Tools Installed.".
}
#endregion
#region Add Powewr Apps Account
Write-Host "Adding Power Platform Account..."
Add-PowerAppsAccount -Endpoint "prod" -TenantID $TenantId -ClientSecret $ClientSecret -ApplicationId $ClientID
#endregion
#region Get Environments
Write-Host "Getting Environments..."
$_Environments = Get-AdminPowerAppEnvironment -Filter *$DomainName*
#endregion
#region Process Environments
foreach ($_Environment in $_Environments) {

    if ($_Environment.Internal.properties.linkedEnvironmentMetadata.domainName -eq $DomainName) {
        
        Write-Host "Found Environemnt"$DomainName", getting environment id and security group id..." 
        $_EnvironmentId = $_Environment.EnvironmentName
        $_EnvironmentSecurityGroupId = $_Environment.SecurityGroupId
    }
    else {

        Write-Warning "Unable to find environment: " $DomainName
    }
}
$_EnvironmentId
$_EnvironmentSecurityGroupId
#endregion
#region Get Power Apps
Write-Host "Getting Canvas Apps..."
$_PowerApps = Get-AdminPowerApp -EnvironmentName $_EnvironmentId
#endregion
#region Process Power Apps
if ($null -eq $_PowerApps) {
    
    Write-Host "No Canvas Apps found...!"
}
else {

    foreach ($_PowerApp in $_PowerApps) {

        if ($null -ne $_PowerApp.Internal.logicalName -and $_PowerApp.Internal.logicalName.ToLower().StartsWith($PublisherPrefix.ToLower())) {
            
            Write-Host "Found PowerApp,"$_PowerApp.DisplayName", sharing with environment security group..." 
            Set-AdminPowerAppRoleAssignment -AppName $_PowerApp.AppName -RoleName $Permissions -PrincipalType 'Group' -PrincipalObjectId $_EnvironmentSecurityGroupId -EnvironmentName $_EnvironmentId
        }
    }
}
#endregion