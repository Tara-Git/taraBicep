@description('The Azure region into which the resources should be deployed.')
param location string = 'westus3'

@description('The name of the App Service app.')
param appServiceAppName string = 'toy-${uniqueString(resourceGroup().id)}'

@description('The name of the App Service plan SKU.')
param appServicePlanSkuName string = 'F1'

var appServicePlanName = 'toy-dog-plan'

module website 'br/ToyCompanyRegistry:16-privateRegistriesWebSite:v1' = {
  name: 'toy-dog-website'
  params: {
    appServiceAppName: appServiceAppName
    appServicePlanName: appServicePlanName
    appServicePlanSkuName: appServicePlanSkuName
    location: location
  }
}

module cdn 'br/ToyCompanyRegistry:16-privateRegistriesCdn:v1' = {
  name: 'toy-dog-cdn'
  params: {
    httpsOnly: true
    originHostName: website.outputs.appServiceAppHostName
  }
}

/*
In case we want to use the module and not using the Alias,  we need to specify the module from the registry like this:

module myModule 'br:myregistry.azurecr.io/modulepath/modulename:moduleversion' = {
  name: 'my-module'
  params: {
    moduleParameter1: 'value'
  }
}
*/

/*
Deploy tge main to azure:

az deployment group create \
   --template-file main.bicep
*/
