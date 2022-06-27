#!/bin/bash

# 1. Generate a client-facing self-signed TLS certificate
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -out appgw.crt -keyout appgw.key -subj "/CN=dronedelivery.fabrikam.com/O=Fabrikam Drone Delivery"
openssl pkcs12 -export -out appgw.pfx -in appgw.crt -inkey appgw.key -passout pass:

# 2. Base64 encode the client-facing certificate.
export APP_GATEWAY_LISTENER_CERTIFICATE=$(cat appgw.pfx | base64 | tr -d '\n')

# 3. Generate the wildcard certificate for the AKS Ingress Controller.
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -out k8sic.crt -keyout k8sic.key -subj "/CN=*.aks-agic.fabrikam.com/O=Fabrikam Aks Ingress"

# 4. Base64 encode the AKS Ingress Controller certificate.
export AKS_INGRESS_CONTROLLER_CERTIFICATE_BASE64=$(cat k8sic.crt | base64  | tr -d '\n')

