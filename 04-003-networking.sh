#!/bin/bash

# 1. Login into the Azure subscription that you'll be deploying the AKS cluster into.
az login
az account set --subscription "585f2373-2ab2-47cd-a1d9-292f98c77d2a"

# 2. Create a resource group for the hub network.
az group create --name rg-enterprise-networking-hubs --location centralus

# 3. Create a resource group for the spoke network.
az group create --name rg-enterprise-networking-spokes --location centralus

# 4. Create the regional network hub.
az deployment group create --resource-group rg-enterprise-networking-hubs --template-file networking/hub-default.json --parameters location=eastus2

# 5. Create the spoke network into which the AKS cluster and adjacent resources will be deployed.
HUB_VNET_ID=$(az deployment group show -g rg-enterprise-networking-hubs -n hub-default --query properties.outputs.hubVnetId.value -o tsv)

# 5.a. Now, deploy the ARM template, which creates the virtual spoke network and other related configurations such as peerings, routing, and diagnostic configurations..
az deployment group create --resource-group rg-enterprise-networking-spokes --template-file networking/spoke-shipping-dronedelivery.json --parameters location=eastus2 hubVnetResourceId="${HUB_VNET_ID}"

# 6. Update the shared, regional hub deployment to account for the requirements of the spoke.
# 6.a. First, get the resource id of the **snet-clusternode** subnet found in the spoke network. This value is used ..
NODEPOOL_SUBNET_RESOURCEIDS=$(az deployment group show -g rg-enterprise-networking-spokes -n spoke-shipping-dronedelivery --query properties.outputs.nodepoolSubnetResourceIds.value -o tsv)
# 6.b. Now deploy the updated template.
az deployment group create --resource-group rg-enterprise-networking-hubs --template-file networking/hub-regionA.json --parameters location=eastus2 nodepoolSubnetResourceIds="['${NODEPOOL_SUBNET_RESOURCEIDS}']" serviceTagsLocation=EastUS2



