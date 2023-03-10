
param dataFactoryName string
param PrimaryLocation string 
param azDevopsRepoConfiguration object


resource dataFactoryName_resource 'Microsoft.DataFactory/factories@2018-06-01' =  {
  name: dataFactoryName
  location: PrimaryLocation
  properties: {
    repoConfiguration: azDevopsRepoConfiguration
  }
}
