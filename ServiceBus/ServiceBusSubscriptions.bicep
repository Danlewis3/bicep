param subscriptionName string
param defaultMessageTimeToLive string
param autoDeleteOnIdle string
param topicName string
param ServiceBusName string

resource subscription 'Microsoft.ServiceBus/namespaces/topics/subscriptions@2021-11-01' = {
  name: '${ServiceBusName}/${topicName}/${subscriptionName}'
   properties: {   
    defaultMessageTimeToLive: defaultMessageTimeToLive  
	autoDeleteOnIdle: autoDeleteOnIdle	
  }
}
