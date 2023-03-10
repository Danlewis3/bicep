param name string
param location string
param sku string
param kind string
param id string
param uniqueName string

resource symbolicname 'Microsoft.Maps/accounts@2021-12-01-preview' = {
  name: name
  location: location
  sku: {
    name: sku
  }
  kind: kind
  identity: {
    type: 'None'
    userAssignedIdentities: {}
  }
  properties: {
    cors: {
      corsRules: [
        {
          allowedOrigins: [
            '*'
          ]
        }
      ]
    }
    disableLocalAuth: false
    linkedResources: [
      {
        id: id
        uniqueName: uniqueName
      }
    ]
  }
}


