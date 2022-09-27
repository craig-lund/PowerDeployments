# Introduction 
```
Usage: pac solution init --publisher-name --publisher-prefix [--outputDirectory]

  --publisher-name            Name of the Dataverse solution publisher (alias: -pn)
  --publisher-prefix          Customization prefix value for the Dataverse solution publisher (alias: -pp)
  --outputDirectory           Output directory (alias: -o)

Usage: pac solution clone --name [--include] [--outputDirectory] [--async] [--max-async-wait-time] [--targetversion]

  --name                      The name of the solution to be exported (alias: -n)
  --include                   Which settings should be included in the solution being exported (alias: -i)
                              Values: autonumbering, calendar, customization, emailtracking, externalapplications, general, isvconfig, marketing, outlooksynchronization, relationshiproles, sales
  --outputDirectory           Output directory (alias: -o)
  --async                     Exports solution asynchronously (alias: -a)
  --max-async-wait-time       Max asynchronous wait time in minutes. Default value is 60 minutes (alias: -wt)
  --targetversion             (deprecated) The version that the exported solution will support (alias: -v)

Usage: pac plugin [init]

  init                        Initializes a directory with a new Dataverse plugin class library.

Usage: pac pcf [init] [push] [version]

  init                        Initializes a directory with a new PowerApps component framework project
  push                        Import the PowerApps component framework project into the current Dataverse Organization

Usage: pac package [init] [add-solution] [add-reference] [deploy] [show]

  init                        Initializes a directory with a new Dataverse package project
  add-solution                Adds a prebuilt Dataverse solution file to a PD Package project
  add-reference               Adds reference to Dataverse solution project
  deploy                      Deploys package to Dataverse environment
  show                        Shows details of Dataverse package

  projectSrc/readme.md
	projectSrc/<namespace>.<”pcf” | “plugin” | “solution” | “package”>.<name>
```