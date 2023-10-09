@description('The Azure region into which the resources should be deployed.')
param location string

@description('The name of the App Service app.')
param appServiceAppName string

@description('The name of the App Service plan.')
param appServicePlanName string

@description('The name of the App Service plan SKU.')
param appServicePlanSkuName string

resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: appServicePlanSkuName
  }
}

resource appServiceApp 'Microsoft.Web/sites@2022-03-01' = {
  name: appServiceAppName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
  }
}

@description('The default host name of the App Service app.')
output appServiceAppHostName string = appServiceApp.properties.defaultHostName




/*
01. Create a container registry:
az acr create \
  --name YOUR_CONTAINER_REGISTRY_NAME \
  --sku Basic \
  --location westus

02. Publish the modules to the registry:
az bicep publish \
  --file website.bicep \
  --target 'br:YOUR_CONTAINER_REGISTRY_NAME.azurecr.io/website:v1'

az bicep publish \
  --file cdn.bicep \
  --target 'br:YOUR_CONTAINER_REGISTRY_NAME.azurecr.io/cdn:v1'

  
03. List the modules in your regitry
  az acr repository list \
  --name YOUR_CONTAINER_REGISTRY_NAME

*/
