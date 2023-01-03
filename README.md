# **Introduction**

Power Platform Projects are used for defining, tracking, developing, and deploying Power Platform solutions. A healthy Application Lifecycle Management (ALM) is key to successful projects.  

Read [Application lifecycle management (ALM) with Microsoft Power Platform](https://learn.microsoft.com/power-platform/alm/overview-alm). The overall concepts are more than DevOps and will be referred to as, Platform Engineering.  

The Power Platform has deep integration capabilities with Microsoft products. These capabilities are not always apparent or easy to understand. I want to put some of those pieces together to demonstrate, using the tooling available, how this can be quickly implemented. There will be very little “code” here unless there is a very specific reason. This repository contains the documentation and resources needed to implement Platform Engineering for the Power Platform.  

Each organization has unique goals and challenges. This is not a "cookie cutter" process but rather a "framework" that can be scaled and adjusted to meet organizational needs. This is not “the only” way but a simple way to get started quickly start learning your project needs and expand as needed. All values are to show examples of possible content.  

Future iterations of this will shift to a "Fusion Development" approach. [Ebook: Fusion development approach](https://learn.microsoft.com/power-apps/guidance/fusion-dev-ebook/)

---

## **Getting Started**

### Tools to achieve results

#### Visual Studio Code

1. [**Download**](https://code.visualstudio.com)
1. **Extensions**

    [PowerShell Develop PowerShell modules, commands and scripts in Visual Studio Code](https://marketplace.visualstudio.com/items?itemName=ms-vscode.PowerShell)  
    [Power Platform Tools, Tooling to create Power Platform solutions & packages, manage Power Platform environments and edit Power Apps Portals](https://marketplace.visualstudio.com/items?itemName=microsoft-IsvExpTools.powerplatform-vscode)
    [Sarif Viewer, Adds support for viewing SARIF logs]( https://marketplace.visualstudio.com/items?itemName=MS-SarifVSCode.sarif-viewer)

1. **PowerShell Modules**

    [Microsoft.PowerApps.Administration.PowerShell](https://www.powershellgallery.com/packages/Microsoft.PowerApps.Administration.PowerShell/)

    This module contains administrator commands for the Power Platform.
    ```powershell
    Install-Module -Name Microsoft.PowerApps.Administration.PowerShell
    ```
    [Microsoft.PowerApps.PowerShell](https://www.powershellgallery.com/packages/Microsoft.PowerApps.PowerShell/)  

    This module contains maker commands for the Power Platform.

    ```powershell
    Install-Module -Name Microsoft.PowerApps.PowerShell
    ```
    [Microsoft.Xrm.Data.Powershell](https://www.powershellgallery.com/packages/Microsoft.Xrm.Data.Powershell/)

    This module contains component tooling for the Dataverse.
    ```powershell
    Install-Module -Name Microsoft.Xrm.Data.Powershell
    ```
    [Microsoft.Xrm.Tooling.ConfigurationMigration](https://www.powershellgallery.com/packages/Microsoft.Xrm.Tooling.ConfigurationMigration/)

    This module conatins 
    ```powershell
    Install-Module -Name Microsoft.Xrm.Tooling.ConfigurationMigration
    ```
    [Xrm.Framework.CI.PowerShell.Cmdlets](https://www.powershellgallery.com/packages/Xrm.Framework.CI.PowerShell.Cmdlets/)
    ```powershell
    Install-Module -Name Xrm.Framework.CI.PowerShell.Cmdlets
    ```
1. **Power Platform Command Line Interface**

    [Learn Power Platform Command Line Interface(CLI)](https://learn.microsoft.com/en-us/power-platform/developer/cli/introduction) 

    [Download for Windows](https://aka.ms/PowerAppsCLI) To uninstall, run the installer and select **Remove**.    

1. **Azure DevOps**
    
    [Sign in or Start for Free](https://azure.microsoft.com/en-us/products/devops/#overview)
    #### **Extensions**
    [Power Platform Build Tools, Automate common build and deployment tasks related to Power Platform](https://marketplace.visualstudio.com/items?itemName=microsoft-IsvExpTools.PowerPlatform-BuildTools)
        
    [Pull Request Merge Conflict, Review and resolve pull request merge conflicts on the web](https://marketplace.visualstudio.com/items?itemName=ms-devlabs.conflicts-tab)
    
    [SARIF SAST Scans Tab, Adds a 'Scans' tab to each Build Result and Work Item for viewing associated SARIF SAST logs](https://marketplace.visualstudio.com/items?itemName=sariftools.scans)
    
    [Microsoft Security DevOps, Build tasks for performing security analysis](https://marketplace.visualstudio.com/items?itemName=ms-securitydevops.microsoft-security-devops-azdevops)

1. **Azure** Components

    [Subscriptions](https://portal.azure.com/#view/Microsoft_Azure_Billing/SubscriptionsBlade)  
    Use resources in an Azure Subscription.  
    [Key Vaults](https://portal.azure.com/#view/HubsExtension/BrowseResource/resourceType/Microsoft.KeyVault%2Fvaults)  
    Use secrets contained in Azure Key Vaults.  
    [App Registrations](https://portal.azure.com/#view/Microsoft_AAD_RegisteredApps/ApplicationsListBlade)   
    Create and managed App Registrations. 

    - Dev-Deployment-App  
        Add to each non-prod environment and assign System Administrator Role.  
        As a Global Office Admin run PowerShell command.   
        ```powershell
        New-PowerAppManagementApp -ApplicationId <clientid>
        ```
    - Deployment-App  
        Add to prod environment and assign System Administrator Role.  
        As a Global Office Admin run PowerShell command.  
        ```powershell
        New-PowerAppManagementApp -ApplicationId <clientid>
        ```

### Define an **Environment Strategy**

1. Read [Environment Strategy](https://learn.microsoft.com/en-us/power-platform/alm/environment-strategy-alm).
1. Create environments as defined by strategy.

    |Type|Domain Name|Domain Suffix   |Url                                 |
    |----|----------:|----------------|------------------------------------|
    |DEV |contoso-dev|crm.dynamics.com|https://contoso-dev.crm.dynamics.com|
    |QAT |contoso-qat|crm.dynamics.com|https://contoso-qat.crm.dynamics.com|
    |UAT |contoso-uat|crm.dynamics.com|https://contoso-uat.crm.dynamics.com|
    |PRD |contoso    |crm.dynamics.com|https://contoso.crm.dynamics.com    |

### Define a Solution Strategy
1. Read [Solution Concepts](https://learn.microsoft.com/en-us/power-platform/alm/solution-concepts-alm).
1. Unmanaged
1. Managed
1. Segmentation
1. Layers
1. Update
1. Upgrade
1. Metadata
1. Components
1. Create solution(s) in your development environment.
    
    Display Name: *"Contoso Sales"  
    Name: *'`ContosoSales`'*
 
---
# **Contribute**

## Branches

- **Main (`main`)**

    The `main` branch holds tested and deployable production ready features. All production deployment should happen **ONLY** from the `main` branch.

- **Release (`release`)**   
 
    The `release` branch, if used, holds a group of tested and deployable features ready to be released. The `release` branch isolates `develop` from `main` in order to support longer testing cycles. The `develop` branch should be created based upon the main branch.

- **Develop (`develop`)**

    The `develop` branch holds testable and deployable features ready to be tested. All **QAT** deployments should happen **ONLY** from the `develop` branch. The `develop` branch should be created based upon the `main` or `release` branch.

- **User (`users`)**

    The `user` branch holds dev environment solution, portal, or data source code. All `user` branches are created under the users folder (required) a unique alias 'users/alias/name'. All `user` branches should be created based upon the `develop` branch.
    
    - **`users/alias/solutionname`**   
        For Solutions the name will be the '**Name**', **NOT** the '*Display Name*', of the solution.   
        Solution branches that are in development or ready for testing. All solution source code should be added to the the solution branch when development is completed. 
    - **`users/alias/portalname`**  
        For Portals the name will be the '**Name**' of the website (record) in the dataverse with '**-**' to replace all spaces between words. For a portal name of "**Contoso Sales**" then the branch name would be "**Contoso-Sales**".  
        Portal branches that are in development or ready for testing. All portal source should be added to the portal branch when development is ready for testing.
        

    ### **Crete User Branch**

    Follow these guidelines and rules when creating a user branch.
    
    Create a branch under the ***`users`*** and ***`alias`*** folder a unique alias `users/alias/name`. The users folder is required and critial to use as commits use this folder path!
    - The alias folder is required and should be unique. 
    - For Solutions the name will be the **Name**, **not** the **Display Name**, of the solution. 
    - For Portals the name will be the '**Name**' of the website (record) in the dataverse with '**-**' to replace all spaces between words. For a portal name of "**Contoso Sales**" then the branch name would be "**Contoso-Sales**".
    - For data the name will be the **Name** of the dataset. For a dataset with the `account_schema.xml` schema file the dataset name would be "**account**".

## Build and Test
1. For Export and commits.   
    The solution name will be parsed from the **`Build.SourceBranchName`** Azure DevOps variable.  
    The portal name will be parsed from the **`Build.SourceBranchName`** Azure DevOps variable.
2. For Build Validation Test imports.   
    The solution name will be parsed from the **`System.PullRequest.SourceBranch`** Azure DevOps variable.  
    The portal name will be parsed from the **`System.PullRequest.SourceBranch`** Azure DevOps variable.