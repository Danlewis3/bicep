
module KeyVaultPermissionsDevDeployment '../../KeyVault/KeyVaultPermissions.bicep'= [for permissions in KeyVaultPermissionsdev : if (Environment =='dev')  {
  name: '${permissions.name}-${Environment}'
  dependsOn: [KeyVaultDeployment]
  scope:  rgkeyvault
  params:{
    KeyVaultName:toLower(KeyVaultName)
    tenantId:tenant().tenantId
    permissiongroupappregistration:permissions.PermissionsID
  }
}]
module KeyVaultPermissionsTestDeployment '../../KeyVault/KeyVaultPermissions.bicep'= [for permissions in KeyVaultPermissionstest : if (Environment =='test')  {
  name: '${permissions.name}-${Environment}'
    dependsOn: [KeyVaultDeployment]
  scope:  rgkeyvault
  params:{
    KeyVaultName:toLower(KeyVaultName)
    tenantId:tenant().tenantId
    permissiongroupappregistration:permissions.PermissionsID
  }
}]
 
module KeyVaultPermissionsDMDeployment '../../KeyVault/KeyVaultPermissions.bicep'= [for permissions in KeyVaultPermissionsdm : if (Environment =='dm')  {
  name: '${permissions.name}-${Environment}'
    dependsOn: [KeyVaultDeployment]
  scope:  rgkeyvault
  params:{
    KeyVaultName:toLower(KeyVaultName)
    tenantId:tenant().tenantId
    permissiongroupappregistration:permissions.PermissionsID
  }
}]
 
module KeyVaultPermissionsUATDeployment '../../KeyVault/KeyVaultPermissions.bicep'= [for permissions in KeyVaultPermissionsuat : if (Environment =='uat')  {
  name: '${permissions.name}-${Environment}'
  dependsOn: [KeyVaultDeployment]
  scope:  rgkeyvault
  params:{
    KeyVaultName:toLower(KeyVaultName)
    tenantId:tenant().tenantId
    permissiongroupappregistration:permissions.PermissionsID
  }
}]
module KeyVaultPermissionsPPDeployment '../../KeyVault/KeyVaultPermissions.bicep'= [for permissions in KeyVaultPermissionspp : if (Environment =='pp')  {
  name: '${permissions.name}-${Environment}'
  dependsOn: [KeyVaultDeployment]
  scope:  rgkeyvault
  params:{
    KeyVaultName:toLower(KeyVaultName)
    tenantId:tenant().tenantId
    permissiongroupappregistration:permissions.PermissionsID
  }
}]
module KeyVaultPermissionsProdDeployment '../../KeyVault/KeyVaultPermissions.bicep'= [for permissions in KeyVaultPermissionsprod : if (Environment =='prod')  {
  name: '${permissions.name}-${Environment}'
  dependsOn: [KeyVaultDeployment]
  scope:  rgkeyvault
  params:{
    KeyVaultName:toLower(KeyVaultName)
    tenantId:tenant().tenantId
    permissiongroupappregistration:permissions.PermissionsID
  }
}]
 