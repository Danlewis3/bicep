
param appName string 
param location string
@secure()
param hostingPlan string
param linuxFxVersion string= 'DOTNETCORE|6.0'
var AppServiceAppName = appName
param language string = '.net'
param API bool
@secure()
param AppInsightsKey string
param AppInsightsConnectionString string
param apimid string ='/subscriptions/5920faa0-cbdb-41c2-86d3-c27aebc58813/resourceGroups/rg-azapp-development-uksouth/providers/Microsoft.ApiManagement/service/development-apim-nps'

var configReference = {
  '.net': {
    appSettings: [
      {
        name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
        value: AppInsightsKey
      }
      {
        name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
        value: AppInsightsConnectionString
      }
    ]
  }
  html: {
    comments: 'HTML app. No additional configuration needed.'
  }
  php: {
    phpVersion: '7.4'
  }
  node: {
    appSettings: [
      {
        name: 'WEBSITE_NODE_DEFAULT_VERSION'
        value: '12.15.0'
      }
      {
        name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
        value: AppInsightsKey
      }
      {
        name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
        value: AppInsightsConnectionString
      }
    ]
  }
}

resource AppService 'Microsoft.Web/sites@2021-03-01' = {
  name: '${AppServiceAppName}-UI'
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    siteConfig: union(configReference[language],{
      alwaysOn: true
      minTlsVersion: '1.2'
      scmMinTlsVersion: '1.2'
      ftpsState: 'FtpsOnly'
      linuxFxVersion: linuxFxVersion
    })
    serverFarmId: hostingPlan
    httpsOnly: true
  }
}


resource AppServiceapi 'Microsoft.Web/sites@2021-03-01' = if (API ==true)  {
  name: '${AppServiceAppName}-API'
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    siteConfig: union(configReference[language],{
      alwaysOn: true
      minTlsVersion: '1.2'
      scmMinTlsVersion: '1.2'
      ftpsState: 'FtpsOnly'
      linuxFxVersion: linuxFxVersion
      apiDefinition: {
        url: 'https://development-citizen-restapi.azurewebsites.net/swagger/v1/swagger.json'
      }
      apiManagementConfig: {
        id: apimid
      }
    })
    serverFarmId: hostingPlan
    httpsOnly: true

}
}
