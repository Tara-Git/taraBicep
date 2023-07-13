param virtualMachines_ToyTruckServer_name string = 'ToyTruckServer'
param disks_ToyTruckServer_OsDisk_1_ab342262da3d4a619526793a286b3aa2_externalid string = '/subscriptions/ffb2054b-934e-4b5b-94cd-a4e745a6f04f/resourceGroups/tara-bicep/providers/Microsoft.Compute/disks/ToyTruckServer_OsDisk_1_ab342262da3d4a619526793a286b3aa2'
param networkInterfaces_toytruckserver124_externalid string = '/subscriptions/ffb2054b-934e-4b5b-94cd-a4e745a6f04f/resourceGroups/tara-bicep/providers/Microsoft.Network/networkInterfaces/toytruckserver124'
param networkInterfaces_toytruckserver124_name string = 'toytruckserver124'
param publicIPAddresses_ToyTruckServer_ip_externalid string = '/subscriptions/ffb2054b-934e-4b5b-94cd-a4e745a6f04f/resourceGroups/tara-bicep/providers/Microsoft.Network/publicIPAddresses/ToyTruckServer-ip'
param virtualNetworks_ToyTruckServer_vnet_externalid string = '/subscriptions/ffb2054b-934e-4b5b-94cd-a4e745a6f04f/resourceGroups/tara-bicep/providers/Microsoft.Network/virtualNetworks/ToyTruckServer-vnet'
param networkSecurityGroups_ToyTruckServer_nsg_externalid string = '/subscriptions/ffb2054b-934e-4b5b-94cd-a4e745a6f04f/resourceGroups/tara-bicep/providers/Microsoft.Network/networkSecurityGroups/ToyTruckServer-nsg'
param virtualNetworks_ToyTruckServer_vnet_name string = 'ToyTruckServer-vnet'
param networkSecurityGroups_ToyTruckServer_nsg_name string = 'ToyTruckServer-nsg'
param publicIPAddresses_ToyTruckServer_ip_name string = 'ToyTruckServer-ip'

resource virtualMachines_ToyTruckServer_name_resource 'Microsoft.Compute/virtualMachines@2023-03-01' = {
  name: virtualMachines_ToyTruckServer_name
  location: 'westeurope'
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_D2s_v3'
    }
    storageProfile: {
      imageReference: {
        publisher: 'canonical'
        offer: '0001-com-ubuntu-server-focal'
        sku: '20_04-lts-gen2'
        version: 'latest'
      }
      osDisk: {
        osType: 'Linux'
        name: '${virtualMachines_ToyTruckServer_name}_OsDisk_1_ab342262da3d4a619526793a286b3aa2'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          storageAccountType: 'Premium_LRS'
          id: disks_ToyTruckServer_OsDisk_1_ab342262da3d4a619526793a286b3aa2_externalid
        }
        deleteOption: 'Delete'
        diskSizeGB: 30
      }
      dataDisks: []
      diskControllerType: 'SCSI'
    }
    osProfile: {
      computerName: virtualMachines_ToyTruckServer_name
      adminUsername: 'toytruckadmin'
      linuxConfiguration: {
        disablePasswordAuthentication: false
        provisionVMAgent: true
        patchSettings: {
          patchMode: 'ImageDefault'
          assessmentMode: 'ImageDefault'
        }
        enableVMAgentPlatformUpdates: false
      }
      secrets: []
      allowExtensionOperations: true
      requireGuestProvisionSignal: true
    }
    securityProfile: {
      uefiSettings: {
        secureBootEnabled: true
        vTpmEnabled: true
      }
      securityType: 'TrustedLaunch'
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterfaces_toytruckserver124_externalid
          properties: {
            deleteOption: 'Detach'
          }
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
  }
}

resource networkInterfaces_toytruckserver124_name_resource 'Microsoft.Network/networkInterfaces@2022-11-01' = {
  name: networkInterfaces_toytruckserver124_name
  location: 'westeurope'
  kind: 'Regular'
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        id: '${networkInterfaces_toytruckserver124_name_resource.id}/ipConfigurations/ipconfig1'
        etag: 'W/"baaba663-905c-4793-995e-4911691e3084"'
        type: 'Microsoft.Network/networkInterfaces/ipConfigurations'
        properties: {
          provisioningState: 'Succeeded'
          privateIPAddress: '10.2.0.4'
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            name: 'ToyTruckServer-ip'
            id: publicIPAddresses_ToyTruckServer_ip_externalid
            properties: {
              provisioningState: 'Succeeded'
              resourceGuid: '42f86be7-4307-48e5-8cd4-3e61305bc296'
              publicIPAddressVersion: 'IPv4'
              publicIPAllocationMethod: 'Dynamic'
              idleTimeoutInMinutes: 4
              ipTags: []
              ipConfiguration: {
                id: '${networkInterfaces_toytruckserver124_name_resource.id}/ipConfigurations/ipconfig1'
              }
              deleteOption: 'Detach'
            }
            type: 'Microsoft.Network/publicIPAddresses'
            sku: {
              name: 'Basic'
              tier: 'Regional'
            }
          }
          subnet: {
            id: '${virtualNetworks_ToyTruckServer_vnet_externalid}/subnets/default'
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
    dnsSettings: {
      dnsServers: []
    }
    enableAcceleratedNetworking: true
    enableIPForwarding: false
    disableTcpStateTracking: false
    networkSecurityGroup: {
      id: networkSecurityGroups_ToyTruckServer_nsg_externalid
    }
    nicType: 'Standard'
  }
}

resource virtualNetworks_ToyTruckServer_vnet_name_resource 'Microsoft.Network/virtualNetworks@2022-11-01' = {
  name: virtualNetworks_ToyTruckServer_vnet_name
  location: 'westeurope'
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.2.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'default'
        id: virtualNetworks_ToyTruckServer_vnet_name_default.id
        properties: {
          addressPrefix: '10.2.0.0/24'
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
        type: 'Microsoft.Network/virtualNetworks/subnets'
      }
    ]
    virtualNetworkPeerings: []
    enableDdosProtection: false
  }
}

resource virtualNetworks_ToyTruckServer_vnet_name_default 'Microsoft.Network/virtualNetworks/subnets@2022-11-01' = {
  name: '${virtualNetworks_ToyTruckServer_vnet_name}/default'
  properties: {
    addressPrefix: '10.2.0.0/24'
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    virtualNetworks_ToyTruckServer_vnet_name_resource
  ]
}

resource networkSecurityGroups_ToyTruckServer_nsg_name_resource 'Microsoft.Network/networkSecurityGroups@2022-11-01' = {
  name: networkSecurityGroups_ToyTruckServer_nsg_name
  location: 'westeurope'
  properties: {
    securityRules: []
  }
}

resource publicIPAddresses_ToyTruckServer_ip_name_resource 'Microsoft.Network/publicIPAddresses@2022-11-01' = {
  name: publicIPAddresses_ToyTruckServer_ip_name
  location: 'westeurope'
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    ipAddress: '20.73.49.64'
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
    ipTags: []
  }
}