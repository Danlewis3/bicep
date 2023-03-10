param location string
param skuname string
param skutier string
param skucapacity int
param DatabaseName string
param SQLServerName string
param SecondaryLocation string
param SandboxEnabled bool


resource PrimaryDb 'Microsoft.Sql/servers/databases@2022-05-01-preview' = if (SandboxEnabled ==true) {
  name: '${SQLServerName}/${DatabaseName}'
  location: location
  sku: {
    name: skuname
    tier: skutier
    capacity: skucapacity
  }
}
output DBID string = PrimaryDb.id

param createMode string = 'OnlineSecondary'
param sourceDatabaseId string 
param zoneRedundant bool = false
param licenseType string = ''
param readScaleOut string = 'Disabled'
param numberOfReplicas int = 0
param minCapacity int = 0
param autoPauseDelay int = 0
param requestedBackupStorageRedundancy string = 'Local'
param secondaryType string = 'Geo'
param ReplicaEnabled bool
param BackupSQLServerName string 


resource serverName_databaseName 'Microsoft.Sql/servers/databases@2022-02-01-preview' = if (ReplicaEnabled ==true) {
  location: SecondaryLocation
  name: '${BackupSQLServerName}/${DatabaseName}'
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
    name: skuname
    tier: skutier
  }
}
