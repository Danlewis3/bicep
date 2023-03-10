param sqlAdministratorLogin string

@secure()
param sqlAdministratorLoginPassword string

param login string = 'AZ_Freedom_SQL_Admins'
param sid string = '6c2c9a00-8e67-4c2f-a447-b3862b3fdfd1'
param tenantId string = '3734172a-e82a-4ac7-a3d3-02949970d5e6'
param SQLServerName string 
param location string 

resource SQLServer 'Microsoft.Sql/servers@2022-05-01-preview' = {
  name: SQLServerName
  location: location
  properties: {
    administratorLogin: sqlAdministratorLogin
    administratorLoginPassword: sqlAdministratorLoginPassword
    administrators: {
      administratorType: 'ActiveDirectory'
      login: login
      sid: sid
      tenantId: tenantId
    }
  }
}

output SQLServerNameID string = SQLServer.id


