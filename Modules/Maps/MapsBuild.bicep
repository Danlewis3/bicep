//Global Variables
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
param MapLocation string
param MapSKU string 
param MapKind string 
param MapStorageAccountname string 
param MapAccountname string 
@secure()
param MapStorageId string


resource rgmaps 'Microsoft.Resources/resourceGroups@2021-01-01' =  {
  name: 'rg-maps-${Environment}'
  location: MapLocation
}
 

module azuremaps '../../AzureMaps/AzureMaps.bicep' = {
  name: 'AzureMapsDeployment'
  scope: rgmaps
  params: {
 id: MapStorageId
 kind:MapKind
 location: MapLocation
 name: MapAccountname
 sku: MapSKU
 uniqueName:MapStorageAccountname
  }
}
