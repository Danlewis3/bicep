param KeyVaultName string 
param secretname string 
@secure()
param keyvaultvalue string

// Declaring a symbolic name for an existing key vault

resource secret 'Microsoft.KeyVault/vaults/secrets@2019-09-01' = {
  name: '${KeyVaultName}/${secretname}'
  properties: {
    value: keyvaultvalue
  }
}
