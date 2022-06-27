#!/bin/bash

# 1. Query for and save your Azure subscription tenant id 
# of for the subscription where the AKS cluster will be deployed. 
# This value is used throughout the reference implementation.
export TENANT_ID=$(az account show --query tenantId --output tsv)

# 2. Log into the tenant associated with the Azure Active Directory 
# instance that will be used to provide identity services to the AKS cluster.
az login
az account set --subscription "585f2373-2ab2-47cd-a1d9-292f98c77d2a"

# 3. Retrieve the tenant ID for this tenant. 
# This value is used when deploying the AKS cluster.
export K8S_RBAC_AAD_PROFILE_TENANTID=$(az account show --query tenantId --output tsv)

# 4. Create the first Azure AD group 
# that will map the Kubernetes Cluster Role Admin. 
# If you already have a security group appropriate for cluster admins, 
# consider using that group and skipping this step. 
# If using your own group, you will need to update group object names throughout the reference implementation.
export K8S_RBAC_AAD_PROFILE_ADMIN_GROUP_OBJECTID=$(az ad group create --display-name aad-to-dronedelivery-cluster-admin --mail-nickname aad-to-dronedelivery-cluster-admin --query id -o tsv)

# 5. Create a break-glass Cluster Admin user 
# for the Fabrikam Drone Delivery AKS cluster.
export K8S_RBAC_AAD_PROFILE_TENANT_DOMAIN_NAME=$(az ad signed-in-user show --query 'userPrincipalName' -o tsv | cut -d '@' -f 2 | sed 's/\"//')
export AKS_ADMIN_OBJECTID=$(az ad user create --display-name=dronedelivery-admin --user-principal-name dronedelivery-admin@${K8S_RBAC_AAD_PROFILE_TENANT_DOMAIN_NAME} --force-change-password-next-sign-in --password ChangeMe! --query id -o tsv)

# 6. Add the new admin user to the new security group 
# to grant the Kubernetes Cluster Admin role.
az ad group member add --group aad-to-dronedelivery-cluster-admin --member-id $AKS_ADMIN_OBJECTID

# 7. Set up groups to map into other Kubernetes Roles. (Optional, fork required).
# In the [`user-facing-cluster-role-aad-group.yaml` file](./cluster-baseline-settings/user-facing-cluster-role-aad-group.yaml), 
# you can replace the four `<replace-with-an-aad-group-object-id-for-this-cluster-role-binding>` placeholders 
# with corresponding new or existing AD groups that map to their purpose 
# for this cluster.
