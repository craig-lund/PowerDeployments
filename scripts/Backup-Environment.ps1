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
    # If connecting with Service Principle, Enter the Client ID for the Service Principle as a string. Otherwise, leave blank.
    [Parameter(Mandatory)]
    [string]$ClientID,
    # If connecting with Service Principle, Enter the Client Secret for the Service Principle as a string. Otherwise, leave blank.
    [Parameter(Mandatory)]
    [string]$ClientSecret,
    # Enter the Tenant ID for the service principal as a string.
    [Parameter(Mandatory)]
    [string]$TenantID,
    # Enter the label for the environment backup. $(Build.BuildId) or $(Release.ReleaseId)
    [Parameter(Mandatory)]
    [string]$BackupLabel,
    # Enter the notes for the environment backup.
    [Parameter(Mandatory)]
    [string]$BackupNotes
)
#region Install Power Apps Administration Module
Write-Host "Checking Install of Tools..."
if ($null -eq (Get-Package -Name Microsoft.PowerApps.Administration.PowerShell -ErrorAction SilentlyContinue)) {

    Write-Host "Installing Power Platform Admin Tools..."
    Install-Module -Name Microsoft.PowerApps.Administration.PowerShell -Force -WarningAction:SilentlyContinue -InformationAction:SilentlyContinue
}
else {
    
    Write-Host "Power Platform Admin Tools Installed."
}
#endregion
#region Add Powewr Apps Account
Write-Host "Adding Power Platform Account..."
Add-PowerAppsAccount -Endpoint "prod" -TenantID $TenantId -ClientSecret $ClientSecret -ApplicationId $ClientID
#endregion
#region Create the back up request text and clear response.
$_BackupRequest = @{
    
    Label = $BackupLabel
    Notes = $BackupNotes
}
$_BackupResponse = $null
#endregion
#region Get Environments
Write-Host "Getting Environment..."
$_Environments = Get-AdminPowerAppEnvironment  *$DomainName* | Sort-Object -Property DisplayName
#endregion
#region backup specified environment
foreach($_Environment in $_Environments){

    if ($_Environment.Internal.properties.linkedEnvironmentMetadata.domainName -eq $DomainName ) {
        Write-Host "Backing up"$_Environment.DisplayName"..."
        $_BackupResponse = Backup-PowerAppEnvironment -EnvironmentName $_Environment.EnvironmentName -BackupRequestDefinition $_BackupRequest
        
        if ($null -ne $BackupResponse) {
            
            Write-Warning $_BackupResponse | ConvertTo-Json
        } 
    }
}
#endregion