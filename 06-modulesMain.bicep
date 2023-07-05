@description('The Azure region into which the resources should be deployed.')
param location string = 'westus3'

@description('The name of the App Service app.')
param appServiceAppName string = 'tara-toy-${uniqueString(resourceGroup().id)}'

@description('The name of the App Service plan SKU.')
param appServicePlanSkuName string = 'F1'

var appServicePlanName = 'tara-toy-product-launch-plan'

@description('Indicates whether a CDN should be deployed.')
param deployCdn bool = true

module app 'modules/06-modulesApp.bicep' = {
  name: 'tara-toy-launch-app'
  params: { 
    appServiceAppName: appServiceAppName 
    appServicePlanName: appServicePlanName 
    appServicePlanSkuName: appServicePlanSkuName 
    location: location 
  }
}

module cdn 'modules/06-modulesCdn.bicep' = if (deployCdn) { 
  name: 'tara-toy-launch-cdn' 
  params: { 
    httpsOnly: true 
    originHostName: app.outputs.appServiceAppHostName 
  } 
}

@description('The host name to use to access the website.')
/* output websiteHostName string = app.outputs.appServiceAppHostName */
output websiteHostName string = deployCdn ? cdn.outputs.endpointHostName : app.outputs.appServiceAppHostName

