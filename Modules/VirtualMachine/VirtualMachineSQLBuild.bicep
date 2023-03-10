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
param PrimaryLocation string
param vmName string
param adminUsername string
@secure()
param adminPassword string
param existingSubnetName string
param existingVirtualNetworkName string

resource rgvm 'Microsoft.Resources/resourceGroups@2021-01-01' =  {
  name: 'rg-virtualmachine-${Environment}-${PrimaryLocation}'
  location: PrimaryLocation
}
 


module VirtualMachineSQL '../../VirtualMachine/VirtualMachineSQL.bicep' = {
  name: 'VirtualMachineSQL'
  scope: rgvm
  params: {
    adminPassword:adminPassword
    adminUsername:adminUsername
    location:PrimaryLocation
    existingSubnetName:existingSubnetName
    existingVirtualNetworkName:existingVirtualNetworkName
    existingVnetResourceGroup:'rg-virtualmachine-${Environment}-${PrimaryLocation}'
    virtualMachineName:vmName
  }
}
