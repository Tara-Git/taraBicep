@description('The Azure region into which the Cosmos DB resources should be deployed.')
param location string = resourceGroup().location

@description('The name of the Cosmos DB account. This name must be globally unique, and it must only include lowercase letters, numbers, and hyphens.')
@minLength(3)
@maxLength(44)
param cosmosDBAccountName string = 'toy-${uniqueString(resourceGroup().id)}'

resource cosmosDBAccount 'Microsoft.DocumentDB/databaseAccounts@2021-04-15' = {
  name: cosmosDBAccountName
  kind: 'GlobalDocumentDB'
  location: location
  properties: {
    consistencyPolicy: {
      defaultConsistencyLevel: 'Session'
    }
    locations: [
      {
        locationName: location
        failoverPriority: 0
        isZoneRedundant: false
      }
    ]
    databaseAccountOfferType: 'Standard'
    enableAutomaticFailover: false
    enableMultipleWriteLocations: false
    backupPolicy: {
      type: 'Continuous'
    }
  }
}





/*
for deploying the resources we hav e2 steps: 

01. Publish the template as a template spec:
az ts create \
  --name ToyCosmosDBAccount \
  --location westus \
  --display-name "Cosmos DB account" \
  --description "This template spec creates a Cosmos DB account that meets our company's requirements." \
  --version 1.0 \
  --template-file main.bicep


02. Deploy the template spec
templateSpecVersionResourceId=$(az ts show \
  --name ToyCosmosDBAccount \
  --version 1.0 \
  --query id \
  --output tsv)
az deployment group create --template-spec $templateSpecVersionResourceId
*/



/*
Do the following changes:

@description('The Azure region into which the Cosmos DB resources should be deployed.')
param location string = resourceGroup().location

@description('The name of the Cosmos DB account. This name must be globally unique, and it must only include lowercase letters, numbers, and hyphens.')
@minLength(3)
@maxLength(44)
param cosmosDBAccountName string = 'toy-${uniqueString(resourceGroup().id)}'

@description('A descriptive name for the role definition.')
param roleDefinitionFriendlyName string = 'Read and Write'

@description('The list of actions that the role definition permits.')
param roleDefinitionDataActions array = [
  'Microsoft.DocumentDB/databaseAccounts/readMetadata'
  'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/items/*'
]

@description('The object ID of the Azure AD principal that should be granted access using the role definition.')
param roleAssignmentPrincipalId string

var roleDefinitionName = guid('sql-role-definition', cosmosDBAccount.id)
var roleAssignmentName = guid('sql-role-assignment', cosmosDBAccount.id)

resource cosmosDBAccount 'Microsoft.DocumentDB/databaseAccounts@2021-04-15' = {
  name: cosmosDBAccountName
  kind: 'GlobalDocumentDB'
  location: location
  properties: {
    consistencyPolicy: {
      defaultConsistencyLevel: 'Session'
    }
    locations: [
      {
        locationName: location
        failoverPriority: 0
        isZoneRedundant: false
      }
    ]
    databaseAccountOfferType: 'Standard'
    enableAutomaticFailover: false
    enableMultipleWriteLocations: false
  }
}

resource roleDefinition 'Microsoft.DocumentDB/databaseAccounts/sqlRoleDefinitions@2021-04-15' = {
  parent: cosmosDBAccount
  name: roleDefinitionName
  properties: {
    roleName: roleDefinitionFriendlyName
    type: 'CustomRole'
    assignableScopes: [
      cosmosDBAccount.id
    ]
    permissions: [
      {
        dataActions: roleDefinitionDataActions
      }
    ]
  }
}

resource roleAssignment 'Microsoft.DocumentDB/databaseAccounts/sqlRoleAssignments@2021-04-15' = {
  parent: cosmosDBAccount
  name: roleAssignmentName
  properties: {
    roleDefinitionId: roleDefinition.id
    principalId: roleAssignmentPrincipalId
    scope: cosmosDBAccount.id
  }
}





and then:
01. Pulish a new version of the template spec:
az ts create \
  --name ToyCosmosDBAccount \
  --version 2.0 \
  --version-description "Adds Cosmos DB role-based access control." \
  --template-file main.bicep


  02. Deploy the new template spec
  templateSpecVersionResourceId=$(az ts show \
  --name ToyCosmosDBAccount \
  --version 2.0 \
  --query id \
  --output tsv)


  userObjectId=$(az ad signed-in-user show --query id --output tsv)
  az deployment group create \
  --template-spec $templateSpecVersionResourceId \
  --parameters roleAssignmentPrincipalId=$userObjectId
*/
