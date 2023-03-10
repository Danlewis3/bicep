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
param KeyVaultName string = 'kv1${Environment}${PrimaryLocation}'
param DefaultPermissionGroup string ='fc6b6272-b5ef-4e46-bb4e-adfdd7c151fb'

resource rgkeyvault 'Microsoft.Resources/resourceGroups@2021-01-01' =  {
  name: 'rg-keyvault-${Environment}-${PrimaryLocation}'
  location: PrimaryLocation
}
module KeyVaultDeployment '../../KeyVault/KeyVaultModule.bicep'={
  name: 'AzureKeyVault'
  scope:  rgkeyvault
  params:{
    KeyVaultName:toLower(KeyVaultName)
    location:PrimaryLocation
    permissiongroup:DefaultPermissionGroup
    tenantId:tenant().tenantId
  }
}
