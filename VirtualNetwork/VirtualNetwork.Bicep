param location string
param addressPrefix string = '10.0.0.0/16'
param subnetName string = 'Subnet'
param subnetPrefix string = '10.0.0.0/24'
param virtualNetworkName string = 'MyVNET'



resource virtualNetwork 'Microsoft.Network/virtualNetworks@2022-05-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]
    }
    subnets: [
      {
        name: subnetName
        properties: {
          addressPrefix: subnetPrefix

          }
        }
      
    ]
  }
}
