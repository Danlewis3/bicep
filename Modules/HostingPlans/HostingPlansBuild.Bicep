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
param KeyVaultName string
param hostingplans array

resource rghostingplans 'Microsoft.Resources/resourceGroups@2021-01-01' =  {
  name: 'rg-azplans-${Environment}-${PrimaryLocation}'
  location: PrimaryLocation
}

module HostingPlans '../../HostingPlans/LinuxHosting.bicep' = [for (function, i) in hostingplans: {
  name: '${function.name}'
  scope: rghostingplans
  params:{
    appServicePlanKind: function.AppServicePlanKind
    location: PrimaryLocation
    name: function.name
    hostingplanskuname:function.HostingTier
    hostingplantier: function.Tier
  }
  }]


  module AzureHostingNamePlanKeyVault '../../KeyVault/KeyVaultSecrets.bicep' =[for (function, i) in hostingplans:{
    name: 'Secret-${Environment}-${i}'
    scope: resourceGroup('rg-keyvault-${Environment}-${PrimaryLocation}')
    params:{
      KeyVaultName: KeyVaultName
      keyvaultvalue: '${function.name}'
      secretname: '${function.secretname}'
    }
    } ]

    module AzureHostingIdPlanKeyVault '../../KeyVault/KeyVaultSecrets.bicep' =[for (function, i) in hostingplans:{
      name: 'SecretId-${Environment}-${i}'
      scope: resourceGroup('rg-keyvault-${Environment}-${PrimaryLocation}')
      dependsOn: [
        AzureHostingNamePlanKeyVault
      ]
      params:{
        KeyVaultName: KeyVaultName
        keyvaultvalue: '/subscriptions/${subscription().subscriptionId}/resourceGroups/rg-azplans-${Environment}-${PrimaryLocation}/providers/Microsoft.web/serverfarms/${function.name}'
        secretname: '${function.secretid}'
      }
      } ]
