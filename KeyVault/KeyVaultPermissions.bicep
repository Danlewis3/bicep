param KeyVaultName string
param permissiongroupappregistration string
param tenantId string

resource keyVaultAccessPolicy 'Microsoft.KeyVault/vaults/accessPolicies@2021-11-01-preview' = {
  name: '${KeyVaultName}/add'
  properties: {
    accessPolicies: [
      {
        objectId: permissiongroupappregistration
        tenantId: tenantId
        permissions: {
          secrets: [
            'all'
          ]
          certificates: [
            'all'
          ]
          keys: [
            'all'
          ]
        }
      } 
           
    ]
  }
}
