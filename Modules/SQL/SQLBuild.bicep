targetScope = 'subscription'
@secure()
param sqlAdministratorLoginPassword string
param sqlAdministratorLogin string 
param PrimarySQLServerName string 
param SecondarySQLServerName string
@allowed([
  'dev'
  'test'
  'dm'
  'uat'
  'pp'
  'prod'
])
param Environment string 
param skucapacity int
param skuname string 
param skutier string
param PrimaryLocation string 
param SecondaryLocation string 
param KeyVaultName string 
param Database array
param SQLServer array


resource rgsql 'Microsoft.Resources/resourceGroups@2021-01-01' =  {
  name: 'rg-azsql-${Environment}'
  location: PrimaryLocation
}

module AzureSQLDeployment '../../SQL/SQLServer.Bicep' = [for (servers, i) in SQLServer : {
  name: 'AzureSQL-${servers.location}-${i}'
  scope: rgsql
  params:{
    location: servers.location
    sqlAdministratorLogin:sqlAdministratorLogin
    sqlAdministratorLoginPassword:sqlAdministratorLoginPassword
    SQLServerName:servers.name
  }
  } ]

  module AzureSQLDatabaseDeployment '../../SQL/SQLDatabase.bicep' = [for database in Database : {
    name: 'AzureSQL-${database.name}'
    scope: rgsql
    dependsOn:[
      AzureSQLDeployment
    ]
    params: {
 location: PrimaryLocation
 SecondaryLocation: SecondaryLocation
 skucapacity : skucapacity
 DatabaseName : database.name
 SQLServerName : PrimarySQLServerName
 skuname:skuname
 skutier:skutier
 ReplicaEnabled: database.ReplicaEnabled
 BackupSQLServerName: SecondarySQLServerName
 sourceDatabaseId: '/subscriptions/${subscription().subscriptionId}/resourceGroups/rg-azsql-${Environment}/providers/Microsoft.Sql/servers/${PrimarySQLServerName}/databases/${database.name}'
 SandboxEnabled:database.SandboxEnabled
    }
    } ]

module AzureSQLKeyVaultPrimaryConnectionString '../../KeyVault/KeyVaultSecrets.bicep' = [for (database,i)in Database : {
    name: 'AzureSQLPrimaryConnectionString-${i}'
    scope: resourceGroup('rg-keyvault-${Environment}-${PrimaryLocation}')
    dependsOn: [
      AzureSQLDatabaseDeployment
    ]
    params:{
      KeyVaultName: KeyVaultName
      keyvaultvalue: 'Server=tcp:${PrimarySQLServerName}.database.windows.net,1433;Initial Catalog=${database.name};Persist Security Info=False;User ID=${sqlAdministratorLogin};Password=${sqlAdministratorLoginPassword};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;'
      secretname: 'AzureSQLConnectionString-${database.name}'
    }
    } ]

