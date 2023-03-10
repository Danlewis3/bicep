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
@secure()
param hostingPlan string
param appName string
param KeyVaultName string
param API bool
@secure()
param AppInsightsConnectionString string
@secure()
param AppInsightsKey string

resource rgAppService 'Microsoft.Resources/resourceGroups@2021-01-01' =  {
  name: 'rg-azplans-${Environment}-${PrimaryLocation}'
  location: PrimaryLocation
}

module AppService '../../AppService/Appservice.bicep' =  {
  name: appName
  scope: rgAppService
  params:{
    appName: appName
    hostingPlan:hostingPlan
    location:PrimaryLocation
    API: API
    AppInsightsConnectionString:AppInsightsConnectionString
    AppInsightsKey:AppInsightsKey
  }
  }

  module AppServiceURL '../../KeyVault/KeyVaultSecrets.bicep' = {
    name: 'Secret-${appName}-URL'
    dependsOn:[AppService]
    scope: resourceGroup('rg-keyvault-${Environment}-${PrimaryLocation}')
    params:{
      KeyVaultName: KeyVaultName
      keyvaultvalue: '${appName}.azurewebsites.net'
      secretname: '${appName}-URL'
    }
    } 
