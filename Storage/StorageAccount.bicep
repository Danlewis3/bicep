
param storageAccountName string
param location string
param storageAccountType string
param allowBlobPublicAccess bool
param KeyVaultName string
param Environment string
param PrimaryLocation string

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-08-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: storageAccountType
  }
  properties: {
    allowBlobPublicAccess: allowBlobPublicAccess
  }
  kind: 'Storage'
}

output storageAccountId string = storageAccount.id
output storagename string = storageAccount.name

module AzureStorageConnectionString '../KeyVault/KeyVaultSecrets.bicep' = {
  name: 'StorageConnectionString-${storageAccount.name}'
  scope:  resourceGroup('rg-keyvault-${Environment}-${PrimaryLocation}')
  params:{
    KeyVaultName: KeyVaultName
    secretname: 'connectionString-${storageAccount.name}'
    keyvaultvalue: 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};AccountKey=${listKeys(storageAccount.id, storageAccount.apiVersion).keys[0].value};EndpointSuffix=${az.environment().suffixes.storage}'
  }
  }

  module AzureStorageId '../KeyVault/KeyVaultSecrets.bicep' = {
    name: 'StorageResourceId-${storageAccount.name}'
    scope:  resourceGroup('rg-keyvault-${Environment}-${PrimaryLocation}')
    params:{
      KeyVaultName: KeyVaultName
      secretname: 'StorageId-${storageAccount.name}'
      keyvaultvalue: '/subscriptions/${subscription().subscriptionId}/resourceGroups/rg-storage-${Environment}-${location}/providers/Microsoft.Storage/storageAccounts/${storageAccount.name}'
    }
    }
  
