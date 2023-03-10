param name string
param Sku string
param location string 

resource serviceBusNamespace 'Microsoft.ServiceBus/namespaces@2021-06-01-preview' = {
  name: name
  location: location
  sku: {
    name: Sku
    tier: Sku
  }
}



