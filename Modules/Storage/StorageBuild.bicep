
param StorageAccounts array

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
param allowBlobPublicAccess bool
param KeyVaultName string


module StorageAccount '../../Storage/StorageAccount.bicep' = [for (storageaccount, i) in StorageAccounts:{
  name: '${storageaccount.name}'
  scope: resourceGroup('rg-storage-${Environment}-${PrimaryLocation}')
  params: {
    location:storageaccount.location
    storageAccountName:storageaccount.name
    storageAccountType:storageaccount.type
    allowBlobPublicAccess:allowBlobPublicAccess
    KeyVaultName:toLower(KeyVaultName)
    Environment: Environment
    PrimaryLocation: PrimaryLocation
  }
}]
