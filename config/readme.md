# Introduction 
Schema files are created using the following tools data can be downloaded.

## Work with Data using Microsoft.Xrm.Tooling.ConfigurationMigration RequiredVersion 1.0.0.61
```
Connect-CrmOnline 
    
    -ServerUrl "https://$DomainName.$DomainSuffix/" 
    -ClientSecret $ClientSecret 
    -OAuthClientId $ClientID 

Export-CrmDataFile 
    
    -CrmConnection $_Connection 
    -SchemaFile $_schemaFilePath 
    -DataFile $_artifactFilePath

Import-CrmDataFile 
    
    -CrmConnection $_Connection 
    -DataFile $_dataFilePath
```
## Work with Data using Power Platform CLI
```
pac data export

  --schemaFile                Schema file name. It can be created using Configuration Migration Tool (alias: -sf)
  --dataFile                  File name for data zip file. Default data.zip (alias: -df)
  --overwrite                 Allow overwrite output data file if it already exists (alias: -o)
  --verbose                   Output more diagnostic information during data import/export (alias: -v)
  --environment               Environment (id, org id, url, unique name or partial name) (alias: -env)

pac data import

  --data                      Zip file or directory name with data for import (alias: -d)
  --verbose                   Output more diagnostic information during data import/export (alias: -v)
  --environment               Environment (id, org id, url, unique name or partial name) (alias: -env)
  --dataDirectory             (deprecated) Directory name with data for import (alias: -dd) 
```
## Work with Data using Xrm.Framework.CI.PowerShell.Cmdlets RequiredVersion 9.1.0.1
```
Expand-XrmCMData 
    
    -DataZip <string> 
    -Folder <string> 
    [-SplitDataXmlFile <bool>] 
    [-SortDataXmlFile <bool>]  
    [<CommonParameters>]

Compress-XrmCMData 
    
    -DataZip <string> 
    -Folder <string> 
    [-CombineDataXmlFile <bool>]  
    [<CommonParameters>]

```
- [XRM PowerShell](https://www.powershellgallery.com/packages/Microsoft.Xrm.Data.Powershell)
- [XRM Configuration Migration PowerShell](https://www.powershellgallery.com/packages/Microsoft.Xrm.Tooling.ConfigurationMigration)
- [XRM CI PowerShell](https://www.powershellgallery.com/packages/Xrm.Framework.CI.PowerShell.Cmdlets)