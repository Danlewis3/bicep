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
param projectName string 
param repositoryName string 
param accountName string
param collaborationBranch string
param rootFolder string = '/azuredatafactory/src'
param dataFactoryName string
param principalId string
param principalType string
param roleName string

var azDevopsRepoConfiguration = {
  accountName: accountName
  repositoryName: repositoryName
  collaborationBranch: collaborationBranch
  rootFolder: rootFolder  
  type: 'FactoryVSTSConfiguration'
  tenantId: '3734172a-e82a-4ac7-a3d3-02949970d5e6'
  projectName: projectName
}

resource rghostingplans 'Microsoft.Resources/resourceGroups@2021-01-01' =  {
  name: 'rg-datafactory-${Environment}-${PrimaryLocation}'
  location: PrimaryLocation
}

module DataFactoryBuild '../../DataFactory/Datafactory.bicep' =  {
  name: 'DataFactoryBuild'
  scope: resourceGroup('rg-datafactory-${Environment}-${PrimaryLocation}')
  params:{
    dataFactoryName:dataFactoryName
    PrimaryLocation:PrimaryLocation
    azDevopsRepoConfiguration: azDevopsRepoConfiguration
  }
  }

  module RolePermissions '../../RolePermissions/RolePermissions.bicep' = {
name: 'RolePermissions'
scope: resourceGroup('rg-datafactory-${Environment}-${PrimaryLocation}')
params:{
  principalId:principalId
  principalType: principalType
  roleName: roleName
}
}

