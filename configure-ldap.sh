#!/bin/bash

# This script runs just as the docker container is booting up and configures 
# sssd to user ldap based on the server and domain of the runtime.  
# See CMD in Dockerfile and test.sh to see how -e sets the HOSTNAME and DOMAIN_NAME

# Set the hostname and domain using environment variables, with defaults
HOSTNAME="${HOSTNAME:-ssh}"
DOMAIN_NAME="${DOMAIN_NAME:-example.com}"

# Set the full hostname
FULL_HOSTNAME="${HOSTNAME}.${DOMAIN_NAME}"
echo "Setting hostname to $FULL_HOSTNAME"
hostnamectl set-hostname "$FULL_HOSTNAME"

# Configure LDAP server in sssd.conf using the domain name
LDAP_SERVER="ldap.${DOMAIN_NAME}"
echo "Configuring LDAP server to use $LDAP_SERVER"

# Update sssd.conf with the specified domain
cat <<EOL > /etc/sssd/sssd.conf
[sssd]
services = nss, pam
config_file_version = 2
domains = LDAP

[domain/LDAP]
id_provider = ldap
auth_provider = ldap
ldap_uri = ldap://${LDAP_SERVER}
ldap_search_base = dc=${DOMAIN_NAME//./,dc=}
ldap_id_use_start_tls = true
ldap_tls_reqcert = demand
ldap_tls_cacert = /etc/ssl/certs/ca-certificates.crt
EOL

chmod 600 /etc/sssd/sssd.conf
chown root:root /etc/sssd/sssd.conf

