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
az deployment group create \
  --template-file main.bicep \
  --parameters environmentType=nonprod

# Verify the deployment 
az deployment group list --output table