# Introduction 
Power Platform projects are used for defining, tracking, developing, and deploying 
User branches store all developed code. Strict nameing conventions are critial to how automation works. Follow the conventions and guidelines indiecated below.

# Getting Started
Follow these steps when creating a user branch. [Solution Concepts] 
1. Determin your solution Strategy. [Solution Concepts](https://learn.microsoft.com/en-us/power-platform/alm/solution-concepts-alm)
    create the **solution** or **portal** you will be working on.
2. Determin your portal strategy. [Power Portals](https://learn.microsoft.com/en-us/power-apps/maker/portals/)
# Contribute
1. Create a user branch under your unique alias 'users/alias/name'. 
    - The alias is a unique identifier for each user.
    - For Solutions the name will be the "Name", **not** the "**Display Name**", of the solution. 
    - For Portals the name be the "Name" of the website (record) in the dataverse with '**-**' to replace all spaces between words. Example: If Name is "Contoso Customer Portal" then the branch name would be "contoso-customer-portal". 
# Build and Test
1. For Export and commits.
    - The solution name will be parsed from the '**Build.SourceBranchName**' Azure DevOps variable.
    - The portal name will be parsed from the '**Build.SourceBranchName**' Azure DevOps variable.
2. For Build Validation Test imports.
    - The solution name will be parsed from the '**System.PullRequest.SourceBranch**' Azure DevOps variable.
    - The portal name will be parsed from the '**System.PullRequest.SourceBranch**' Azure DevOps variable.