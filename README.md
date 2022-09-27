# Introduction 
Power Platform projects are used for defining, tracking, developing, and deploying 
User branches store all developed code. Strict nameing conventions are critial to how automation works. Follow the conventions and guidelines indiecated below.

# Getting Started
1. Determin your solution Strategy. [Solution Concepts](https://learn.microsoft.com/en-us/power-platform/alm/solution-concepts-alm)
    create the **solution** or **portal** you will be working on.
2. Determin your portal strategy. [Power Portals](https://learn.microsoft.com/en-us/power-apps/maker/portals/)
## Contribute
Follow these steps when creating a user branch.
- Create a user branch under your unique alias 'users/alias/name'. 
    - The alias is a unique identifier for each user.
    - For Solutions the name will be the **Name**, **not** the **Display Name**, of the solution. 
    - For Portals the name be the "Name" of the website (record) in the dataverse with '**-**' to replace all spaces between words. Example: If Name is "Contoso Customer Portal" then the branch name would be "contoso-customer-portal". 
## Build and Test
1. For Export and commits.
    - The solution name will be parsed from the '**Build.SourceBranchName**' Azure DevOps variable.
    - The portal name will be parsed from the '**Build.SourceBranchName**' Azure DevOps variable.
2. For Build Validation Test imports.
    - The solution name will be parsed from the '**System.PullRequest.SourceBranch**' Azure DevOps variable.
    - The portal name will be parsed from the '**System.PullRequest.SourceBranch**' Azure DevOps variable.
## Environments
Example (adjust to meet organization needs) [Environment Strategy](https://learn.microsoft.com/en-us/power-platform/alm/environment-strategy-alm)
|Type|Domain Name|Domain Suffix|Url
|----|-------------|----------------|-------------------|
|DEV|contoso-dev|crm.dynamics.com|https://contoso-dev.crm.dynamics.com
|SIT|contoso-sit|crm.dynamics.com|https://contoso-sit.crm.dynamics.com
|UAT|contoso-uat|crm.dynamics.com|https://contoso-uat.crm.dynamics.com
|PROD|contoso|crm.dynamics.com|https://contoso.crm.dynamics.com
admin## Active Directory (AD) Security Groups

Example (adjust to meet organizational needs) [Dataverse Security](https://learn.microsoft.com/en-us/power-platform/admin/control-user-access).Expand as needed for each environment and role needed.

- D365-con-dev
    - Assign any AD user to access this environment
    - Assign License to security group
- D365-con-sit
    - Assign any AD user to access this environment
    - Assign License to security group
- D365-con-uat
    - Assign any AD user to access this environment
    - Assign License to security group
- D365-con-prod
    - Assign any AD user to access this environment
    - Assign License to security group
- Project Administrators
    - System Administrator Power Platform role assigned
    - Linked to team in the Power Platform
    - Linked to Azure DevOps team
- Project Contributors
    - System Customizer Power Platform role assigned 
    - Linked to team in the Power Platform
    - Linked to Azure DevOps team
## Azure Application Registration

Example (adjust to meet organizational needs) [Azure App Registration (SPN)](#).

- CON-PowerPlatform-dev-ServicePrincipal
    - Add to each environment and assign System Customizer Role
- CON-PowerPlatform-adm-ServicePrincipal
    - Add to each environment and assign System Administrator Role
    - As a Global Office Admin run PowerShell command.
        ```
        - New-PowerAppManagementApp -ApplicationId <clientid>
        ```
## Extensions
- [Power Platform Build Tools](https://marketplace.visualstudio.com/items?itemName=microsoft-IsvExpTools.PowerPlatform-BuildTools).
- [Pull Request Merge Conflict](https://marketplace.visualstudio.com/items?itemName=ms-devlabs.conflicts-tab).
- [SARIF SAST Scans Tab](https://marketplace.visualstudio.com/items?itemName=sariftools.scans).
