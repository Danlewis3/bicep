param location string 
param KeyVaultName string
param permissiongroup string
param tenantId string

module KeyVaultDeployment './KeyVault.bicep' ={
  name: 'KeyVaultDeployment'
  params:{
    location:location
    name: toLower(KeyVaultName)
    permissiongroup:permissiongroup
    tenantId:tenantId
  }
  }    
