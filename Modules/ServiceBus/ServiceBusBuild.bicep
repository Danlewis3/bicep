
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
param KeyVaultName string
param ServiceBusSKU string 
param QueueNames array
param TopicName string 
param autoDeleteOnIdle string 
param defaultMessageTimeToLive string 
param subscriptionName string 
 


resource rgservicebus 'Microsoft.Resources/resourceGroups@2021-01-01' =  {
  name: 'rg-servicebus-${Environment}-${PrimaryLocation}'
  location: PrimaryLocation
  }
module ServiceBus '../../ServiceBus/ServiceBus.Bicep' = {
  name: 'ServiceBus'
  scope: rgservicebus
  params:{
    location:PrimaryLocation
    name: 'sb${Environment}${PrimaryLocation}'
    Sku:ServiceBusSKU
    }
    }

module ServiceBusQueue '../../ServiceBus/ServiceBusQueues.bicep' = [for queues in QueueNames: {
name: 'ServiceBusQueue-${queues}'
    scope: rgservicebus
    params:{
      queueName:queues
      ServiceBusName:'sb${Environment}${PrimaryLocation}'
    }
  } ]
 
  module ServiceBusTopic '../../ServiceBus/ServiceBusTopic.bicep' =  {
    name: 'ServiceBusTopic'
        scope: rgservicebus
        dependsOn: [
          ServiceBus
        ]
        params:{
          autoDeleteOnIdle:autoDeleteOnIdle
          defaultMessageTimeToLive:defaultMessageTimeToLive
          topicName: TopicName
          ServiceBusName:'sb${Environment}${PrimaryLocation}'
        }
      }
 
      module ServiceBusTopicURL '../../KeyVault/KeyVaultSecrets.bicep' ={
        name: 'ServiceBusTopicURL'
        scope: resourceGroup('rg-keyvault-${Environment}-${PrimaryLocation}')
        dependsOn: [
          ServiceBusTopic
        ]
        params:{
          KeyVaultName: KeyVaultName
          keyvaultvalue: 'https://sb${Environment}${PrimaryLocation}.servicebus.windows.net/${TopicName}'
          secretname: '${TopicName}-URL'
        }
        }  
 

      module ServiceBusSubscriptions '../../ServiceBus/ServiceBusSubscriptions.bicep' =  {
        name: 'ServiceBusSubscriptions'
            scope: rgservicebus
            dependsOn:[
              ServiceBus
              ServiceBusQueue
              ServiceBusTopic
            ]
            params:{
              subscriptionName:subscriptionName
              autoDeleteOnIdle:autoDeleteOnIdle
              defaultMessageTimeToLive:defaultMessageTimeToLive
              ServiceBusName:'sb${Environment}${PrimaryLocation}'
              topicName:TopicName
            }
          }
   