param name string
param hostingplanskuname string
param location string 
param appServicePlanKind string
param hostingplantier string

resource hostingPlan 'Microsoft.Web/serverfarms@2021-03-01' = {
  name: name
  location: location
  sku: {
    name: hostingplanskuname
    tier: hostingplantier
  }
  kind: appServicePlanKind
  properties: {
    reserved: true
  }
}

output hostingid string = hostingPlan.id
