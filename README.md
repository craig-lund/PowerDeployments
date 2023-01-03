# Introduction 
User branches store all developed code. Branch nameing conventions are critial to how some automation works. Follow the conventions and guidelines indiecated below.

# Getting Started
Follow these steps when creating a user branch. 
1. Determin or create the **solution** or **portal** you will be working on.
2. Create a user branch under your unique alias 'users/alias/name'. 
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
