param name string
param type string = 'web'
param location string 
param requestSource string = 'CustomDeployment'


resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2020-08-01' = {
  name: name
  location: location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 120
    features: {
      searchVersion: 1
      legacy: 0
      enableLogAccessUsingOnlyResourcePermissions: true
    }
  }
}
resource insights 'Microsoft.Insights/components@2020-02-02' = {
  name: name
  location: location
  kind: 'other'
  properties: {
    Application_Type: type
    Flow_Type: 'Bluefield'
    Request_Source: requestSource
    WorkspaceResourceId: logAnalyticsWorkspace.id

  }
}

output InsightsKey string = insights.properties.InstrumentationKey

