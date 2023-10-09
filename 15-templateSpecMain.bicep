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
