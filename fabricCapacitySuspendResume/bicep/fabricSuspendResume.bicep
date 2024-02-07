param logicAppName string 
param location string
param actionSuspendResume string
param fabricCapacityName string
param fabricResourceGroup string
param fabricSubscriptionId string


var managementUrl = environment().resourceManager


resource r_LogicApp 'Microsoft.Logic/workflows@2017-07-01' = {
  name: logicAppName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    state: 'Enabled'
    definition: {
      '$schema': 'https://schema.management.azure.com/providers/Microsoft.Logic/schemas/2016-06-01/workflowdefinition.json#'
      contentVersion: '1.0.0.0'
      parameters: {
        action: {
          defaultValue: actionSuspendResume
          type: 'String'
        }
        capacityName: {
          defaultValue: fabricCapacityName
          type: 'String'
        }
        resourceGroupName: {
          defaultValue: fabricResourceGroup
          type: 'String'
        }
        subscriptionId: {
          defaultValue: fabricSubscriptionId
          type: 'String'
        }
      }
      triggers: {
        Recurrence: {
          recurrence: {
            frequency: 'Day'
            interval: 1
            schedule: {}
          }
          evaluatedRecurrence: {
            frequency: 'Day'
            interval: 1
            schedule: {}
          }
          type: 'Recurrence'
        }
      }
      actions: {
        HTTP: {
          runAfter: {}
          type: 'Http'
          inputs: {
            authentication: {
              audience: managementUrl
              type: 'ManagedServiceIdentity'
            }
            method: 'POST'
            uri: '${managementUrl}/subscriptions/@{parameters(\'subscriptionId\')}/resourceGroups/@{parameters(\'resourceGroupName\')}/providers/Microsoft.Fabric/capacities/@{parameters(\'capacityName\')}/@{parameters(\'action\')}?api-version=2022-07-01-preview'
          }
        }
      }
      outputs: {}
    }
    parameters: {}
  }
}
