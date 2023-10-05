@description('The Azure region into which the resources should be deployed.')
param location string

@description('The name of the App Service app to deploy. This name must be globally unique.')
param appServiceAppName string

@description('The name of the storage account to deploy. This name must be globally unique.')
param storageAccountName string

@description('The name of the queue to deploy for processing orders.')
param processOrderQueueName string

@description('The type of the environment. This must be nonprod or prod.')
@allowed([
  'nonprod'
  'prod'
])
param environmentType string

var storageAccountSkuName = (environmentType == 'prod') ? 'Standard_GRS' : 'Standard_LRS'
var processOrderQueueName = 'processorder'

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: storageAccountSkuName
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
  }

  resource queueServices 'queueServices' existing = {
    name: 'default'

    resource processOrderQueue 'queues' = {
      name: processOrderQueueName
    }
  }
}

resource appServiceApp 'Microsoft.Web/sites@2022-03-01' = {
  name: appServiceAppName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
    siteConfig: {
      appSettings: [
        {
          name: 'StorageAccountName'
          value: storageAccountName
        }
        {
          name: 'ProcessOrderQueueName'
          value: processOrderQueueName
        }
      ]
    }
  }
}

output appServiceAppHostName string = appService.outputs.appServiceAppHostName
