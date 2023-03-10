param topicName string
param defaultMessageTimeToLive string
param autoDeleteOnIdle string
param ServiceBusName string

resource topic 'Microsoft.ServiceBus/namespaces/topics@2021-11-01' = {
  name: '${ServiceBusName}/${topicName}'
   properties: {   
    defaultMessageTimeToLive: defaultMessageTimeToLive  
	  autoDeleteOnIdle: autoDeleteOnIdle
  }
}

