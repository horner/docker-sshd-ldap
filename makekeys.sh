#!/bin/bash

# This scriot is only used to make ssh keys for the server and the client whent he docker is built.
# See the Dockerfile where these keys are copied into.

# Check if the ssh_server_keys folder exists; if not, create it and generate keys
# The keys are kept to prevent the need to accept the fingerprint when connecting to the SSH server 
# over multiple builds
if [ ! -d ./ssh_server_keys ]; then
    echo "ssh_server_keys folder not found. Creating folder and generating keys."

    # Create the folder for SSH server keys
    mkdir -p ./ssh_server_keys

    # Generate SSH server keys and place them in the folder
    ssh-keygen -t rsa -b 4096 -f ./ssh_server_keys/ssh_host_rsa_key -N ""
    ssh-keygen -t ecdsa -b 521 -f ./ssh_server_keys/ssh_host_ecdsa_key -N ""
    ssh-keygen -t ed25519 -f ./ssh_server_keys/ssh_host_ed25519_key -N ""

    echo "Keys have been generated."
else
    echo "ssh_server_keys folder already exists. Skipping key generation."
fi

# Generate the user client SSH key if it does not already exist
# since the docker is built with the id_rsa key, dont loose it. ;)
[ ! -f ./id_rsa ] && ssh-keygen -t rsa -b 4096 -f ./id_rsa -N ""

