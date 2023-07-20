targetScope = 'subscription'

resource policyDefinition 'Microsoft.Authorization/policyDefinitions@2020-09-01' = {
  name: 'my-policy'
  // (other properties related to the policy definition)
}
