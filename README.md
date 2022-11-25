# Introduction 

Power Platform DevOps projects are used for defining, tracking, developing, and deploying Power Platform solutions. A healthy Application Lifecycle Management (ALM) is key to successful projects. Read [Application lifecycle management (ALM) with Microsoft Power Platform](https://learn.microsoft.com/en-us/power-platform/alm/overview-alm).

Each organization has unique challenges and goals. This is not a "cookie cutter" process but rather a "framework" that can be scaled and adjusted to meet organizational needs. 

---
# Getting Started

## Define an Environment Strategy
1. Read [Environment Strategy](https://learn.microsoft.com/en-us/power-platform/alm/environment-strategy-alm).
2. Create environments as defined by strategy.

    **Example**
    |Type|Domain Name|Domain Suffix   |Url                                 |
    |----|----------:|----------------|------------------------------------|
    |DEV |contoso-dev|crm.dynamics.com|https://contoso-dev.crm.dynamics.com|
    |TST |contoso-tst|crm.dynamics.com|https://contoso-tst.crm.dynamics.com|
    |PROD|contoso    |crm.dynamics.com|https://contoso.crm.dynamics.com    |
    | 

## Define a Solution Strategy
1. Read [Solution Concepts](https://learn.microsoft.com/en-us/power-platform/alm/solution-concepts-alm).
2. Create solutions in your development environment.

---
# Contribute

## Branches
- **Main (main)**

    The main branch holds tested and deployable production ready source code. All production deployment should happen **ONLY** from the ***main*** branch.

- **Develop (develop)**

    The develop branch holds testable and deployable source code ready to be tested. All TST deployments should happen **ONLY** from the develop branch. The develop branch should be created based upon the main branch.

- **User (users)**

    The user branch holds dev environment solution, portal, or data source code. All user branches are created under the users folder (required) a unique alias 'users/alias/name'. All user branches should be created based upon the develop branch.
    
    - **`users/alias/solutionname`**
        - For Solutions the name will be the '**Name**', **not** the '**Display Name**', of the solution. 
        - Solution branches that are in development or ready for testing. All solution source code should be added to the the solution branch when development is ready for testing. 
    - **`users/alias/portalname`**
        - For Portals the name will be the '**Name**' of the website (record) in the dataverse with '**-**' to replace all spaces between words. For a portal name of "**Contoso Customer Service**" then the branch name would be "**Contoso-Customer-Service**". 
        - Portal branches that are in development or ready for testing. All portal source should be added to the portal branch when development is ready for testing.
    - **`users/alias/dataname`**
        - For data the name will be the **Name** of the dataset. For a dataset with the `account_schema.xml` schema file the dataset name would be "**account**". 
        - Data branches that are in development or ready for testing. All sata source code should be added to the the data branch when creation is ready for testing and deployment.
        
    ### Crete User Branch

    Follow these guidelines and rules when creating a user branch.
    
    >Create a branch under the ***users*** and ***alias*** folder your unique alias `users/alias/name`. 
    >- The users folder is required and critial to use as commits use this folder path!
    >- The alias folder is required and should be unique. 
    >- For Solutions the name will be the **Name**, **not** the **Display Name**, of the solution. 
    >- For Portals the name will be the '**Name**' of the website (record) in the dataverse with '**-**' to replace all spaces between words. For a portal name of "**Contoso Customer Service**" then the branch name would be "**Contoso-Customer-Service**".
    >- For data the name will be the **Name** of the dataset. For a dataset with the `account_schema.xml` schema file the dataset name would be "**account**".

## Build and Test
1. For Export and commits.
    - The solution name will be parsed from the '**Build.SourceBranchName**' Azure DevOps variable.
    - The portal name will be parsed from the '**Build.SourceBranchName**' Azure DevOps variable.
2. For Build Validation Test imports.
    - The solution name will be parsed from the '**System.PullRequest.SourceBranch**' Azure DevOps variable.
    - The portal name will be parsed from the '**System.PullRequest.SourceBranch**' Azure DevOps variable.

---
# Azure

## Active Directory (AD) Security Groups

Example: (adjust to meet organization needs) [Dataverse Security](https://learn.microsoft.com/en-us/power-platform/admin/control-user-access). Expand as needed for each environment and role needed.

- D365-DEV-ENV
    - Assign any AD user to access this environment
- D365-TST-ENV
    - Assign any AD user to access this environment
- D365-PRD-ENV
    - Assign any AD user to access this environment
- D365-SYS-ADMINISTRATORS
    - System Administrator Power Platform role assigned
    - Linked to team in the Power Platform
    - Linked to Azure DevOps team
- Project Contributors
    - System Customizer Power Platform role assigned 
    - Linked to team in the Power Platform
    - Linked to Azure DevOps team
## Azure Application Registration

Example: (adjust to meet organization needs) [Azure App Registration (SPN)](#).

- Dev-Deployment-App
    - Add to each non-prod environment and assign System Administrator Role
    - As a Global Office Admin run PowerShell command.
        ```powershell
        - New-PowerAppManagementApp -ApplicationId <clientid>
        ```
- Deployment-App
    - Add to prod environment and assign System Administrator Role
    - As a Global Office Admin run PowerShell command.
        ```powershell
        - New-PowerAppManagementApp -ApplicationId <clientid>
        ```
---
# Azure DevOps

## Extensions
- [Power Platform Build Tools](https://marketplace.visualstudio.com/items?itemName=microsoft-IsvExpTools.PowerPlatform-BuildTools).
- [Pull Request Merge Conflict](https://marketplace.visualstudio.com/items?itemName=ms-devlabs.conflicts-tab).
- [SARIF SAST Scans Tab](https://marketplace.visualstudio.com/items?itemName=sariftools.scans).
## Teams