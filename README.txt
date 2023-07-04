az account show 
s=$(az account show --subscription <subscription id> --query id --output tsv)
az account set --subscription $s

az deployment group create \
  --template-file main.bicep \
  --resource-group storage-resource-group

bicep build main.bicep

# Decompile any ARM template into a Bicep template
bicep decompile

# Ensure you have the latest version of Bicep
az bicep install && az bicep upgrade

# Sign in to Azure
az login

# Set the default subscription for all of the Azure CLI commands 
az account set --subscription {your subscription ID}
# OR
az account show 
s=$(az account show --subscription {your subscription ID} --query id --output tsv)
az account set --subscription $s

# Get the Concierge Subscription IDs
az account list \
   --refresh \
   --query "[?contains(name, 'Concierge Subscription')].id" \
   --output table

# Set the default to the resource group
az configure --defaults group=[Your resource group name]

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