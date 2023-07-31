az account show 
s=$(az account show --subscription <subscription id> --query id --output tsv)
az account set --subscription $s

# -------------------------------------
az deployment group create \
  --template-file main.bicep \
  --resource-group storage-resource-group

bicep build main.bicep

# -------------------------------------
# Decompile any ARM template into a Bicep template
bicep decompile

# -------------------------------------
# Ensure you have the latest version of Bicep
az bicep install && az bicep upgrade

# -------------------------------------
# Sign in to Azure
az login

# -------------------------------------
# Set the default subscription for all of the Azure CLI commands 
az account set --subscription {your subscription ID}
# OR
az account show 
s=$(az account show --subscription {your subscription ID} --query id --output tsv)
az account set --subscription $s

# -------------------------------------
# Get the Concierge Subscription IDs
az account list \
   --refresh \
   --query "[?contains(name, 'Concierge Subscription')].id" \
   --output table

# -------------------------------------
# Set the default to the resource group
az configure --defaults group=[Your resource group name]

# -------------------------------------
# Deploy the Bicep template to Azure
az deployment group create --template-file main.bicep
# OR
az deployment group create \
  --template-file main.bicep \
  --parameters environmentType=nonprod
# OR
az deployment group create \
  --template-file main.bicep \
  --parameters main.parameters.json \
               appServicePlanInstanceCount=5
# OR
az deployment group create \
  --mode Complete \
  --name ExampleDeployment \
  --resource-group ExampleResourceGroup \
  --template-file storage.json \
  --result-format FullResourcePayloads

# Deploy in differenet Scops
az deployment group create
  az deployment group create --resource-group ProjectTeddybear 
az deployment sub create
az deployment mg create
az deployment tenant create
# deployment to subscription example
# 1 
  templateFile="main.bicep"
  today=$(date +"%d-%b-%Y")
  deploymentName="sub-scope-"$today
# 2
templateFile="13-deploySubScopeMain.bicep"
today=$(date +"%d-%b-%Y")
deploymentName="sub-scope-"$today
virtualNetworkName="rnd-vnet-001"
virtualNetworkAddressPrefix="10.0.0.0/24"
az deployment sub create \
    --name $deploymentName \
    --location westus \
    --template-file $templateFile \
    --parameters virtualNetworkName=$virtualNetworkName \
                 virtualNetworkAddressPrefix=$virtualNetworkAddressPrefix

  az deployment sub create \
      --name $deploymentName \
      --location westus \
      --template-file $templateFile


# Verify the deployment 
az deployment group list --output table

# Create Keyvaut and userName and password
keyVaultName='YOUR-KEY-VAULT-NAME'
read -s -p "Enter the login name: " login
read -s -p "Enter the password: " password

az keyvault create --name $keyVaultName --location westus3 --enabled-for-template-deployment true
az keyvault secret set --vault-name $keyVaultName --name "sqlServerAdministratorLogin" --value $login --output none
az keyvault secret set --vault-name $keyVaultName --name "sqlServerAdministratorPassword" --value $password --output none

# Retrieve the key vault's resource ID
az keyvault show --name $keyVaultName --query id --output tsv

# Retrieve the Storage access key
az storage account list --resource-group <resource-group-name> --query [].name --output tsv
az storage account keys list --account-name <storage-account-name> --resource-group <resource-group-name> --output table

# Create a Log Analytics workspace
az monitor log-analytics workspace create \
  --workspace-name <Name> \
  --location <location>

# Create a storage account
az storage account create \
--name {storageaccountname} \
--location <location>

# check the role assignment ID
az role assignment list --assignee <user-principal-name> --query [*].id -o tsv
admin@MngEnvMCAP296260.onmicrosoft.com

# Create Bicep from json
az bicep decompile --file template.json

#  Clean up the resources
az group delete --resource-group <resource-group Name> --yes --no-wait
subscriptionId=$(az account show --query 'id' --output tsv)
az policy assignment delete --name 'DenyFandGSeriesVMs' --scope "/subscriptions/$subscriptionId"
az policy definition delete --name 'DenyFandGSeriesVMs' --subscription $subscriptionId
az group delete --name ToyNetworking

# create a Management Group
az account management-group create \
  --name SecretRND \
  --display-name "Secret R&D Projects" --parent-id

  #Review the logs
  az deployment-scripts show-log --resource-group $resourceGroupName --name CopyConfigScript

# List the content of the blob coontainer
storageAccountName=$(az deployment group show --resource-group $resourceGroupName --name $deploymentName --query 'properties.outputs.storageAccountName.value' --output tsv)
az storage blob list --account-name $storageAccountName --container-name config --query '[].name'

# Create a template spec
az ts create \
  --name StorageWithoutSAS \
  --location westus \
  --display-name "Storage account with SAS disabled" \
  --description "This template spec creates a storage account, which is preconfigured to disable SAS authentication." \
  --version 1.0 \
  --template-file main.bicep

  # deploy a template spec to a resource group
    az deployment group create \
    --template-spec "/subscriptions/f0750bbe-ea75-4ae5-b24d-a92ca601da2c/resourceGroups/SharedTemplates/providers/Microsoft.Resources/templateSpecs/StorageWithoutSAS"
    az deployment group create
    az deployment sub create
    az deployment mg create
    az deployment tenant create

# Publish the template as a template spec
  az ts create \
  --name ToyCosmosDBAccount \
  --location westus \
  --display-name "Cosmos DB account" \
  --description "This template spec creates a Cosmos DB account that meets our company's requirements." \
  --version 1.0 \
  --template-file main.bicep

# Get the template spec version's resource ID 
templateSpecVersionResourceId=$(az ts show \
  --name ToyCosmosDBAccount \
  --version 1.0 \
  --query id \
  --output tsv)

# create a service principal without any Azure role assignments
az ad sp create-for-rbac --name MyPipeline

# reset a key for a service principal
az ad sp credential reset --name "b585b740-942d-44e9-9126-f1181c95d497"

# sign in by using the service principal's credentials.
az login --service-principal \
  --username APPLICATION_ID \
  --password SERVICE_PRINCIPAL_KEY \
  --tenant TENANT_ID \
  --allow-no-subscriptions


# create a role assignment for a service principal
az role assignment create \
  --assignee b585b740-942d-44e9-9126-f1181c95d497 \
  --role Contributor \
  --scope "/subscriptions/f0750bbe-ea75-4ae5-b24d-a92ca601da2c/resourceGroups/ToyWebsite" \
  --description "The deployment pipeline for the company's website needs to be able to create resources within the resource group."

# create a role assignment at the same time that you create a service principal
az ad sp create-for-rbac \
  --name MyPipeline \
  --role Contributor \
  --scopes "/subscriptions/f0750bbe-ea75-4ae5-b24d-a92ca601da2c/resourceGroups/ToyWebsite"

# Create Role Assignment
az role assignment create \
  --assignee APPLICATION_ID \
  --role Contributor \
  --scope RESOURCE_GROUP_ID \
  --description "The deployment pipeline for the company's website needs to be able to create resources within the resource group."