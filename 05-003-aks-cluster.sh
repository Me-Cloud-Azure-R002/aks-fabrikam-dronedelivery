#!/bin/bash

az login
az account set --subscription "585f2373-2ab2-47cd-a1d9-292f98c77d2a"

# 1. Create the AKS cluster and the Azure Container Registry resource groups.
az deployment sub create --name workload-stamp-prereqs --location eastus2 --template-file ./workload/workload-stamp-prereqs.json --parameters resourceGroupLocation=eastus2
az deployment sub create --name cluster-stamp-prereqs --location eastus --template-file cluster-stamp-prereqs.json --parameters resourceGroupName=rg-shipping-dronedelivery resourceGroupLocation=eastus

DELIVERY_ID_NAME=$(az deployment group show -g rg-shipping-dronedelivery -n workload-stamp-prereqs-dep --query properties.outputs.deliveryIdName.value -o tsv) && \
DELIVERY_ID_PRINCIPAL_ID=$(az identity show -g rg-shipping-dronedelivery -n $DELIVERY_ID_NAME --query principalId -o tsv) && \
DRONESCHEDULER_ID_NAME=$(az deployment group show -g rg-shipping-dronedelivery -n workload-stamp-prereqs-dep --query properties.outputs.droneSchedulerIdName.value -o tsv) && \
DRONESCHEDULER_ID_PRINCIPAL_ID=$(az identity show -g rg-shipping-dronedelivery -n $DRONESCHEDULER_ID_NAME --query principalId -o tsv) && \
WORKFLOW_ID_NAME=$(az deployment group show -g rg-shipping-dronedelivery -n workload-stamp-prereqs-dep --query properties.outputs.workflowIdName.value -o tsv) && \
WORKFLOW_ID_PRINCIPAL_ID=$(az identity show -g rg-shipping-dronedelivery -n $WORKFLOW_ID_NAME --query principalId -o tsv) && \
INGRESS_CONTROLLER_ID_NAME=$(az deployment group show -g rg-shipping-dronedelivery -n cluster-stamp-prereqs-identities --query properties.outputs.appGatewayControllerIdName.value -o tsv) && \
INGRESS_CONTROLLER_ID_PRINCIPAL_ID=$(az identity show -g rg-shipping-dronedelivery -n $INGRESS_CONTROLLER_ID_NAME --query principalId -o tsv) && \
PACKAGER_ID_NAME=$(az deployment group show -g rg-shipping-dronedelivery -n workload-stamp-prereqs-dep --query properties.outputs.packageIdName.value -o tsv) && \
PACKAGER_ID_PRINCIPAL_ID=$(az identity show -g rg-shipping-dronedelivery -n $PACKAGER_ID_NAME --query principalId -o tsv) && \
INGESTION_ID_NAME=$(az deployment group show -g rg-shipping-dronedelivery -n workload-stamp-prereqs-dep --query properties.outputs.ingestionIdName.value -o tsv) && \
INGESTION_ID_PRINCIPAL_ID=$(az identity show -g rg-shipping-dronedelivery -n $INGESTION_ID_NAME --query principalId -o tsv)

echo 'Vars -  Review ----------------------------------------------------------------------------------------------------------------'
echo 'Var -  DELIVERY_ID_NAME='    ${DELIVERY_ID_NAME}
echo 'Var -  DELIVERY_ID_PRINCIPAL_ID='    ${DELIVERY_ID_PRINCIPAL_ID}
echo 'Var -  DRONESCHEDULER_ID_NAME='    ${DRONESCHEDULER_ID_NAME}
echo 'Var -  DRONESCHEDULER_ID_PRINCIPAL_ID='    ${DRONESCHEDULER_ID_PRINCIPAL_ID}
echo 'Var -  WORKFLOW_ID_NAME='    ${WORKFLOW_ID_NAME}
echo 'Var -  WORKFLOW_ID_PRINCIPAL_ID='    ${WORKFLOW_ID_PRINCIPAL_ID}
echo 'Var -  INGRESS_CONTROLLER_ID_NAME='    ${INGRESS_CONTROLLER_ID_NAME}
echo 'Var -  INGRESS_CONTROLLER_ID_PRINCIPAL_ID='    ${INGRESS_CONTROLLER_ID_PRINCIPAL_ID}
echo 'Var -  PACKAGER_ID_NAME='    ${PACKAGER_ID_NAME}
echo 'Var -  PACKAGER_ID_PRINCIPAL_ID='    ${PACKAGER_ID_PRINCIPAL_ID}
echo 'Var -  INGESTION_ID_NAME='    ${INGESTION_ID_NAME}
echo 'Var -  INGESTION_ID_PRINCIPAL_ID='    ${INGESTION_ID_PRINCIPAL_ID}

# 2. Wait for Azure AD propagation of the AKS Fabrikam Drone Delivery 00's user identities.
until az ad sp show --id ${DELIVERY_ID_PRINCIPAL_ID} &> /dev/null ; do echo "Waiting for AAD propagation" && sleep 5; done
until az ad sp show --id ${DRONESCHEDULER_ID_PRINCIPAL_ID} &> /dev/null ; do echo "Waiting for AAD propagation" && sleep 5; done
until az ad sp show --id ${WORKFLOW_ID_PRINCIPAL_ID} &> /dev/null ; do echo "Waiting for AAD propagation" && sleep 5; done
until az ad sp show --id ${INGRESS_CONTROLLER_ID_PRINCIPAL_ID} &> /dev/null ; do echo "Waiting for AAD propagation" && sleep 5; done
until az ad sp show --id ${PACKAGER_ID_PRINCIPAL_ID} &> /dev/null ; do echo "Waiting for AAD propagation" && sleep 5; done
until az ad sp show --id ${INGESTION_ID_PRINCIPAL_ID} &> /dev/null ; do echo "Waiting for AAD propagation" && sleep 5; done

echo 'Vars -  Review ----------------------------------------------------------------------------------------------------------------'
echo 'Vars - DELIVERY_ID_PRINCIPAL_ID=' ${DELIVERY_ID_PRINCIPAL_ID}
echo 'Vars - DRONESCHEDULER_ID_PRINCIPAL_ID=' ${DRONESCHEDULER_ID_PRINCIPAL_ID}
echo 'Vars - WORKFLOW_ID_PRINCIPAL_ID=' ${WORKFLOW_ID_PRINCIPAL_ID}
echo 'Vars - INGRESS_CONTROLLER_ID_PRINCIPAL_ID=' ${INGRESS_CONTROLLER_ID_PRINCIPAL_ID}
echo 'Vars - PACKAGER_ID_PRINCIPAL_ID=' ${PACKAGER_ID_PRINCIPAL_ID}
echo 'Vars - INGESTION_ID_PRINCIPAL_ID=' ${INGESTION_ID_PRINCIPAL_ID}

# 3. Get the AKS cluster spoke VNet resource ID.
TARGET_VNET_RESOURCE_ID=$(az deployment group show -g rg-enterprise-networking-spokes -n spoke-shipping-dronedelivery --query properties.outputs.clusterVnetResourceId.value -o tsv)

# 4. Deploy the Azure Container Registry ARM template.
az deployment group create -f ./workload/workload-stamp.json -g rg-shipping-dronedelivery -p packagePrincipalId=$PACKAGER_ID_PRINCIPAL_ID -p ingestionPrincipalId=$INGESTION_ID_PRINCIPAL_ID -p droneSchedulerPrincipalId=$DRONESCHEDULER_ID_PRINCIPAL_ID -p workflowPrincipalId=$WORKFLOW_ID_PRINCIPAL_ID -p deliveryPrincipalId=$DELIVERY_ID_PRINCIPAL_ID # -p acrResourceGroupName=$ACR_RESOURCE_GROUP

# 5. Get the Azure Container Registry deployment output variables
# ACR_NAME=$(az deployment group show -g rg-shipping-dronedelivery -n workload-stamp --query properties.outputs.acrName.value -o tsv) && \
# ACR_SERVER=$(az acr show -n $ACR_NAME --query loginServer -o tsv)

# 6. Deploy the cluster ARM template.
# az deployment group create --resource-group rg-shipping-dronedelivery --template-file cluster-stamp.json --parameters targetVnetResourceId=$TARGET_VNET_RESOURCE_ID k8sRbacAadProfileAdminGroupObjectID=$K8S_RBAC_AAD_PROFILE_ADMIN_GROUP_OBJECTID k8sRbacAadProfileTenantId=$K8S_RBAC_AAD_PROFILE_TENANTID appGatewayListenerCertificate=$APP_GATEWAY_LISTENER_CERTIFICATE aksIngressControllerCertificate=$AKS_INGRESS_CONTROLLER_CERTIFICATE_BASE64 deliveryIdName=$DELIVERY_ID_NAME  droneSchedulerIdName=$DRONESCHEDULER_ID_NAME workflowIdName=$WORKFLOW_ID_NAME ingressControllerIdName=$INGRESS_CONTROLLER_ID_NAME ingressControllerPrincipalId=$INGRESS_CONTROLLER_ID_PRINCIPAL_ID acrResourceGroupName=$ACR_RESOURCE_GROUP acrName=$ACR_NAME



