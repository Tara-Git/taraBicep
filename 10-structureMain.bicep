@description('The location into which your Azure resources should be deployed.')
param location string = resourceGroup().location

@description('Select the type of environment you want to provision. Allowed values are Production and Test.')
@allowed([
  'Production'
  'Test'
])
param environmentType string = 'Test'

var environmentConfigurationMap = {
  Production: {
    appServicePlan: {
      sku: {
        name: 'S1'
        capacity: 2
      }
    }
    storageAccount: {
      sku: 'Standard_GRS'
    }
    sqlDatabase: {
      sku: {
        name: 'S1'
        tier: 'Standard'
      }
    }
  }
  Test: {
    appServicePlan: {
      sku: {
        name: 'F1'
        capacity: 1
      }
    }
    storageAccount: {
      sku: {
        name: 'Standard_LRS'
      }
    }
    sqlDatabase: {
      sku: {
        name: 'Basic'
      }
    }
  }
}

@description('The Admin login username for SQL server.')
param sqlAdministratorLogin string


@secure()
@description('The Administrator login pass for the SQL server.')
param sqlAdministratorLoginPassword string

param resourceNameSuffix string = uniqueString(resourceGroup().id)

var appServicePlanName = 'AppServicePlan'
var appServiceAppName = 'webSite${resourceNameSuffix}'
var sqlserverName = 'toywebsite${resourceNameSuffix}'
var sqlDatabaseName = 'ToyCompanyWebsite'
var storageAccountName = 'toywebsite${resourceNameSuffix}'
var applicationInsightsName = 'AppInsights'
var managedIdentityName = 'WebSite'
var blobContainerNames = [
  'productspecs'
  'productmanuals'
]

@description('The role definition ID of the built-in Azure \'Contributor\' role.')
var contributorRoleDefinitionID = 'b24988ac-6180-42a0-ab88-20f7382dd24c'
var storageAccountConnectionString = 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${listKeys(storageAccount.id, storageAccount.apiVersion).keys[0].value}'

resource storageAccount 'Microsoft.Storage/storageAccounts@2019-06-01' = {
  name: storageAccountName
  location: 'eastus'
  sku: {
    name: environmentConfigurationMap[environmentType].storageAccount.sku
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
  }

  resource blobServices 'blobServices' existing = {
    name: 'default'

    resource containers 'containers' = [for blobContainerName in blobContainerNames: {
      name: blobContainerName
    }]
  }
}

/* The other ways of createing containers
param productmanualsName string = 'productmanuals'
01.
resource productmanuals 'Microsoft.Storage/storageAccounts/blobServices/containers@2019-06-01' = {
  name: '${storageAccount.name}/default/${productmanualsName}'
}

02.
param container1Name string = 'productspecs'
resource container1 'Microsoft.Storage/storageAccounts/blobServices/containers@2019-06-01' = {
  parent: storageAccount::blobServices
  name: container1Name
}
*/

resource sqlServer 'Microsoft.Sql/servers@2019-06-01-preview' = {
  name: sqlserverName
  location: location
  properties: {
    administratorLogin: sqlAdministratorLogin
    administratorLoginPassword: sqlAdministratorLoginPassword
    version: '12.0'
  }
}

resource sqlserverNameDatabaseName 'Microsoft.Sql/servers/databases@2020-08-01-preview' = {
  parent: sqlServer
  name: sqlDatabaseName
  location: location
  sku:environmentConfigurationMap[environmentType].sqlDatabase.sku
}

resource sqlFirewallRuleAllowAzureIPs 'Microsoft.Sql/servers/firewallRules@2014-04-01' = {
  parent: sqlServer
  name: 'AllowAllAzureIPs'
  properties: {
    endIpAddress: '0.0.0.0'
    startIpAddress: '0.0.0.0'
  }
}

resource appServicePlan 'Microsoft.Web/serverfarms@2020-06-01' = {
  name: appServicePlanName
  location: location
  sku: environmentConfigurationMap[environmentType].appServicePlan.sku
}

resource appServiceApp 'Microsoft.Web/sites@2020-06-01' = {
  name: appServiceAppName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      appSettings: [
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: applicationInsights.properties.InstrumentationKey
        }
        {
          name: 'StorageAccountConnectionString'
          value: storageAccountConnectionString
        }
      ]
    }
  }
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${managedIdentity.id}': {} // This format is required when working with user-assigned managed identities.
    }
  }
}

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: managedIdentityName
  location: location
}

@description('Grant the \'Contributor\' role to the user-assigned managed identity, at the scope of the resource group.')
resource roleassignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(contributorRoleDefinitionID, resourceGroup().id) // Create a GUID based on the role definition ID and scope (resource group ID). This will return the same GUID every time the template is deployed to the same resource group.

  properties: {
    principalType: 'ServicePrincipal'
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', contributorRoleDefinitionID)
    principalId: managedIdentity.properties.principalId
    description: 'Grant the "Contributor" role to the user-assigned managed identity so it can access the storage account.'
  }
}

resource applicationInsights 'Microsoft.Insights/components@2018-05-01-preview' = {
  name: applicationInsightsName
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
  }
}
