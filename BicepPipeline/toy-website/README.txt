# log in to Azure
az login

# Create a resourceGroup
az group create --name ToyWebsite --location eastus  # make sure that you are saving ID somewhere

# Create a Service Principal
az ad sp create-for-rbac --name ToyWebsitePipeline

# Check the Service Principal
az login --service-principal \
  --username APPLICATION_ID \
  --password SERVICE_PRINCIPAL_KEY \
  --tenant TENANT_ID \
  --allow-no-subscriptions

# Create Role Assignment
az role assignment create \
  --assignee APPLICATION_ID \
  --role Contributor \
  --scope RESOURCE_GROUP_ID \
  --subscription SUBSCRIPTION_ID \
  --description "The deployment pipeline for the company's website needs to be able to create resources within the resource group."
