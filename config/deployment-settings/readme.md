# Help:
Create a settings file from solution zip or solution folder.

# Commands:
Usage: pac solution create-settings [--solution-zip] [--solution-folder] [--settings-file]

  --solution-zip              Path to solution zip file. (alias: -z)
  --solution-folder           Path to the local, unpacked solution folder: either the root of the 'Other/Solution.xml' file or a folder with a .cdsproj file. (alias: -f)
  --settings-file             The .json file with the deployment settings for connection references and environment variables. (alias: -s)

```json
  {
    "EnvironmentVariables": [
      {
        "SchemaName": "tst_Deployment_env",
        "Value": "Test"
      }
    ],
    "ConnectionReferences": [
      {
        "LogicalName": "tst_sharedtst5fcreateuserandjob5ffeb85c4c63870282_b4cc7",
        "ConnectionId": "4445162937b84457a3465d2f0c2cab7e",
        "ConnectorId": "/providers/Microsoft.PowerApps/apis/shared_tst-5fcreateuserandjob-5ff805fab2693f57dc"
      }
    ]
  }
  ```