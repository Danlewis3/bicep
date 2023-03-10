param queueName string
param ServiceBusName string


resource queues 'Microsoft.ServiceBus/namespaces/queues@2018-01-01-preview' = {
  name:  '${ServiceBusName}/${queueName}'
}
