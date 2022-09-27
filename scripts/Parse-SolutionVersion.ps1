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
    # Enter the domain suffix of the environment to connect to. Example: For https://contoso.crm.dynamics.com/ the domain name would be crm.dynamics.com.
    [Parameter(Mandatory)]
    [string]$DomainSuffix,
    # Enter the name (not the display name) of the solution.
    [Parameter(Mandatory)]
    [string]$SolutionName,
    # If connecting with Service Principle, Enter the Client ID for the Service Principle as a string. Otherwise, leave blank.
    [Parameter(Mandatory)]
    [string]$ClientID,
    # If connecting with Service Principle, Enter the Client Secret for the Service Principle as a string. Otherwise, leave blank.
    [Parameter(Mandatory)]
    [string]$ClientSecret,
    # Enter the amount to increase the Major version, as a whole number.
    [Parameter()]
    [int]$MajorIncrement,
    # Enter the amount to increase the Minor version, as a whole number.  
    [Parameter()]
    [int]$MinorIncrement,
    # Enter the amount to increase the Build version, as a whole number.
    [Parameter()]
    [int]$BuildIncrement,
    # Enter the amount to increase the Revision version, as a whole number.  
    [Parameter()]
    [int]$RevisionIncrement
)
#region Install Power Platform PowerShell Tools
Write-Host "Checking Install of Tools..."
if ($null -eq (Get-Package -Name Microsoft.Xrm.Data.Powershell -ErrorAction SilentlyContinue)) {

    Write-Host "Installing XRM Data PowerShell..."
    Install-Module -Name Microsoft.Xrm.Data.Powershell -Force -WarningAction:SilentlyContinue -InformationAction:SilentlyContinue
}
else {
    Write-Host "XRM Data PowerShell Installed"
}
#endregion
#region Create PowerShell Connection
Write-Host "Connecting to"$DomainName"..."
$_Connection = Connect-CrmOnline -ServerUrl "https://$DomainName.$DomainSuffix/" -ClientSecret $ClientSecret -OAuthClientId $ClientID
#endregion
#region Process string version to ints
if ($_Connection.IsReady -eq $true) {
    
    Write-Host "Getting Solution Version..."
    $_Solutions = Get-CrmRecords -EntityLogicalName solution -FilterAttribute uniquename -FilterOperator eq -FilterValue $SolutionName -Fields version -conn $_Connection 
}
else {
    
    Write-Warning "Connection not ready!"
}
if ($_Solutions.Count -gt 0) {
    
    Write-Host "Parsing solution version..."
    $_Solutions.CrmRecords[0].version
    
    $versionArray = $_Solutions.CrmRecords[0].version.ToCharArray()

    $_temp = $null
    $_major = $null
    $_minor = $null
    $_build = $null
    $_revision = $null

    for ($i = 0; $i -lt $versionArray.Count; $i++) {
    
        switch ($versionArray[$i]) {

            '0' { 
        
                if ($null -eq $_temp) {
                        
                    $_temp = 0
                    if ($i -eq $versionArray.Count-1) {
                    
                        $_revision = $_temp          
                    }
                }
                else {
                    
                    $_temp = ($_temp*10)+0
                    if ($i -eq $versionArray.Count-1) {
                    
                        $_revision = $_temp          
                    }
                }
             }
            '1' { 
        
                if ($null -eq $_temp) {
                        
                    $_temp = 1
                    if ($i -eq $versionArray.Count-1) {
                    
                        $_revision = $_temp          
                    }
                }
                else {
                    
                    $_temp = ($_temp*10)+1
                    if ($i -eq $versionArray.Count-1) {
                    
                        $_revision = $_temp          
                    }
                }
             }
            '2' { 

                if ($null -eq $_temp) {
                        
                    $_temp = 2
                    if ($i -eq $versionArray.Count-1) {
                    
                        $_revision = $_temp          
                    }
                }
                else {
                    
                    $_temp = ($_temp*10)+2
                    if ($i -eq $versionArray.Count-1) {
                    
                        $_revision = $_temp          
                    }
                }
             }
            '3' { 

                if ($null -eq $_temp) {
                        
                    $_temp = 3
                    if ($i -eq $versionArray.Count-1) {
                    
                        $_revision = $_temp          
                    }
                }
                else {
                    
                    $_temp = ($_temp*10)+3
                    if ($i -eq $versionArray.Count-1) {
                    
                        $_revision = $_temp          
                    }
                }
             }
            '4' { 

                if ($null -eq $_temp) {
                        
                    $_temp = 4
                    if ($i -eq $versionArray.Count-1) {
                    
                        $_revision = $_temp          
                    }
                }
                else {
                    
                    $_temp = ($_temp*10)+4
                    if ($i -eq $versionArray.Count-1) {
                    
                        $_revision = $_temp          
                    }
                }
             }
            '5' { 

                if ($null -eq $_temp) {
                        
                    $_temp = 5
                    if ($i -eq $versionArray.Count-1) {
                    
                        $_revision = $_temp          
                    }
                }
                else {
                    
                    $_temp = ($_temp*10)+5
                    if ($i -eq $versionArray.Count-1) {
                    
                        $_revision = $_temp          
                    }
                }
             }
            '6' { 

                if ($null -eq $_temp) {
                        
                    $_temp = 6
                    if ($i -eq $versionArray.Count-1) {
                    
                        $_revision = $_temp          
                    }
                }
                else {
                    
                    $_temp = ($_temp*10)+6
                    if ($i -eq $versionArray.Count-1) {
                    
                        $_revision = $_temp          
                    }
                }
             }
            '7' { 

                if ($null -eq $_temp) {
                        
                    $_temp = 7
                    if ($i -eq $versionArray.Count-1) {
                    
                        $_revision = $_temp          
                    }
                }
                else {
                    
                    $_temp = ($_temp*10)+7
                    if ($i -eq $versionArray.Count-1) {
                    
                        $_revision = $_temp          
                    }
                }
             }
            '8' { 

                if ($null -eq $_temp) {
                        
                    $_temp = 8
                    if ($i -eq $versionArray.Count-1) {
                    
                        $_revision = $_temp          
                    }
                }
                else {
                    
                    $_temp = ($_temp*10)+8
                    if ($i -eq $versionArray.Count-1) {
                    
                        $_revision = $_temp          
                    }
                }
             }
            '9' { 

                if ($null -eq $_temp) {
                        
                    $_temp = 9
                    if ($i -eq $versionArray.Count-1) {
                    
                        $_revision = $_temp          
                    }
                }
                else {
                    
                    $_temp = ($_temp*10)+9
                    if ($i -eq $versionArray.Count-1) {
                    
                        $_revision = $_temp          
                    }
                }
             }
            '.' { 
        
                if ($null -eq $_major) {
                        
                    $_major = $_temp
                    $_temp = $null
                }
                if ($null -eq $_minor) {
                    
                    $_minor = $_temp
                    $_temp = $null
                }
                if ($null -eq $_build) {
                    
                    $_build = $_temp
                    $_temp = $null
                }
            }
        }
    }
    
    $_major += $MajorIncrement
    $_minor += $MinorIncrement
    $_build += $BuildIncrement
    $_revision += $RevisionIncrement

    Write-Host $_major'.'$_minor'.'$_build'.'$_revision
    $_SolutionVersion = $_major.ToString()+"."+$_minor.ToString()+"."+$_build.ToString()+"."+$_revision.ToString()

    Write-Host "##vso[task.setvariable variable=Major]$_major"
    Write-Host "##vso[task.setvariable variable=Minor]$_minor"
    Write-Host "##vso[task.setvariable variable=Build]$_build"
    Write-Host "##vso[task.setvariable variable=Revision]$_revision"
    Write-Host "##vso[task.setvariable variable=SolutionVersion]$_SolutionVersion"
}
else {
    
    Write-Warning "No Solutions found!"
}
#endregion