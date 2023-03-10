targetScope = 'subscription'
@allowed([
  'dev'
  'test'
  'dm'
  'uat'
  'pp'
  'prod'
])
param Environment string 
param PrimaryLocation string

param principalId string
param principalType string
param roleName string

param KeyVaultName string

resource rginsights 'Microsoft.Resources/resourceGroups@2021-01-01' =  {
  name: 'rg-logging-${Environment}-${PrimaryLocation}'
  location: PrimaryLocation
}

module appinsights '../../AppInsights/Appinsights.bicep' = {
name: 'AzureAppInsights'
scope: rginsights
params:{
location:PrimaryLocation
name: 'appinsights-${Environment}'
}
}

module RolePermissions '../../RolePermissions/RolePermissions.bicep' = {
  name: 'RolePermissions'
  scope: resourceGroup('rg-logging-${Environment}-${PrimaryLocation}')
  params:{
    principalId:principalId
    principalType: principalType
    roleName: roleName
  }
  }

  module KeyVaultAppInsights '../../KeyVault/KeyVaultSecrets.bicep' = {
    name: 'AppInsights-Key'
    scope: resourceGroup('rg-keyvault-${Environment}-${PrimaryLocation}')
    dependsOn: [
      appinsights
    ]
    params:{
      KeyVaultName: KeyVaultName
      keyvaultvalue: appinsights.outputs.InsightsKey
      secretname: 'appinsightskey'
    }
    } 


    module KeyVaultAppInsightsConnection '../../KeyVault/KeyVaultSecrets.bicep' = {
      name: 'AppInsightsConnectionString'
      scope: resourceGroup('rg-keyvault-${Environment}-${PrimaryLocation}')
      dependsOn: [
        appinsights
      ]
      params:{
        KeyVaultName: KeyVaultName
        keyvaultvalue: 'InstrumentationKey=${appinsights.outputs.InsightsKey};IngestionEndpoint=https://uksouth-1.in.applicationinsights.azure.com/;LiveEndpoint=https://uksouth.livediagnostics.monitor.azure.com/'
        secretname: 'AppInsightsConnectionString'
      }
      } 
  