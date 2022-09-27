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
    # Enter the domain name of the environment to connect to. Example: For https://contoso.crm.dynamics.com/ the domain name would be contoso.
    [Parameter(Mandatory)]
    [string]$DomainName,
    # Enter the domain suffix of the environment to connect to. Example: For https://contoso.crm.dynamics.com/ the domain name would be crm.dynamics.com.
    [Parameter(Mandatory)]
    [string]$DomainSuffix,
    # If connecting with Service Principle, Enter the Client ID for the Service Principle as a string. Otherwise, leave blank.
    [Parameter()]
    [string]$ClientID,
    # If connecting with Service Principle, Enter the Client Secret for the Service Principle as a string. Otherwise, leave blank.
    [Parameter()]
    [string]$ClientSecret,
    # Enter the TenantID of the Organization to connect to.
    [Parameter(Mandatory)]
    [string]$TenantId,
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
$_url = "https://"+$DomainName+"."+$DomainSuffix+"/"
$_schemaFilePath = $ConfigPath+"\schema\"+$DataSetName+"_schema.xml"
$_artifactFilePath = $ArtifactPath+"\data\"+$DataSetName+"_data.zip"
$_dataFolderPath = $ConfigPath+"\data\"+$DataSetName+"\"
mkdir $ArtifactPath\data -InformationAction SilentlyContinue -ErrorAction SilentlyContinue
Write-Debug $_schemaFilePath
Write-Debug $_artifactFilePath
Write-Debug $_dataFolderPath
#endregion
if ($DataSetName -eq "none") {
    
    Write-Host "No dataset defined, exiting..."
}
else {

    #region Install PowerShell Tools
    if ($null -eq (Get-Package -Name Microsoft.Xrm.Data.Powershell -ErrorAction SilentlyContinue)) {

        Write-Host "Installing Power Platform XRM Data Tools..."
        Install-Module -Name Microsoft.Xrm.Data.Powershell -Force -WarningAction:SilentlyContinue -InformationAction:SilentlyContinue
    }
    else {

        Write-Host "Power Platform XRM Data Tools Installed."
    }
    if ($null -eq (Get-Package -Name Microsoft.Xrm.Tooling.ConfigurationMigration -ErrorAction SilentlyContinue)) {

        Write-Host "Installing Power Platform Configuration Migration Tools..."
        Install-Module -Name Microsoft.Xrm.Tooling.ConfigurationMigration -Force -RequiredVersion 1.0.0.61 -WarningAction:SilentlyContinue -InformationAction:SilentlyContinue
    }
    else {

        Write-Host "Power Platform Configuration Migration Tools Installed."
    }
    if ($null -eq (Get-Package -Name Xrm.Framework.CI.PowerShell.Cmdlets -ErrorAction SilentlyContinue)) {

        Write-Host "Installing XRM CI Tools..."
        Install-Module -Name Xrm.Framework.CI.PowerShell.Cmdlets -RequiredVersion 9.1.0.1 -Force -WarningAction:SilentlyContinue -InformationAction:SilentlyContinue
    }
    else {

        Write-Host "XRM CI Tools Installed."
    }
    #endregion
    #region Create PowerShell Connection
    Write-Host "Creating connection..."
    $_Connection = Connect-CrmOnline -ServerUrl $_url -ClientSecret $ClientSecret -OAuthClientId $ClientID
    #endregion
    #region Export Data
    Write-Host "Export data..."
    Export-CrmDataFile -CrmConnection $_Connection -SchemaFile $_schemaFilePath -DataFile $_artifactFilePath -LogWriteDirectory $ArtifactPath
    #endregion
    #region Import Data
    Write-Host "Unpack data..."
    Expand-XrmCMData -DataZip $_artifactFilePath -Folder $_dataFolderPath -SplitDataXmlFile $true -SortDataXmlFile $true
    #endregion
}