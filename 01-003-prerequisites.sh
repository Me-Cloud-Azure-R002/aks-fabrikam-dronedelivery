#!/bin/bash

# Anaconda - Initiation
conda env list
conda activate AT0001-JavascriptFrameworks
anaconda-navigator

# Azure initial provisioning
az login
az account list
## az account set --subscription "585f2373-2ab2-47cd-a1d9-292f98c77d2a"
## Provide the Subscription Id as argument number 1.
az account set --subscription "$1"

# Install jq
sudo apt-get install jq

# Install Helm
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash

