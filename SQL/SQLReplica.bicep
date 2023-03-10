param databaseName string
param serverName string 
param location string  
param createMode string = 'OnlineSecondary'
param sourceDatabaseId string 
param skuName string 
param tier string
param zoneRedundant bool = false
param licenseType string = ''
param readScaleOut string = 'Disabled'
param numberOfReplicas int = 0
param minCapacity int = 0
param autoPauseDelay int = 0
param requestedBackupStorageRedundancy string = 'Local'
param secondaryType string = 'Geo'

resource serverName_databaseName 'Microsoft.Sql/servers/databases@2022-02-01-preview' = {
  location: location
  name: '${serverName}/${databaseName}'
  properties: {
    createMode: createMode
    secondaryType: secondaryType
    sourceDatabaseId: sourceDatabaseId
    zoneRedundant: zoneRedundant
    licenseType: licenseType
    readScale: readScaleOut
    highAvailabilityReplicaCount: numberOfReplicas
    minCapacity: minCapacity
    autoPauseDelay: autoPauseDelay
    requestedBackupStorageRedundancy: requestedBackupStorageRedundancy
  }
  sku: {
    name: skuName
    tier: tier
  }
}
