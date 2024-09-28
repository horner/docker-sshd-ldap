#!/bin/bash

# This is the main script

./makekeys.sh
docker build -t sshd-ldap .

# I like to have this inline:  that way I kill and restart the docker in one bash history.
# the rm kills and removes the old instance, and the docker runs a new one.
# -n is a good way to name a contaier and kill it quickly. 
docker rm -f sshd-ldap; docker run -d --name sshd-ldap -p 2222:2222 -e HOSTNAME=doug -e DOMAIN_NAME=mieweb.com sshd-ldap

# test the ssh connection and accpet the fingerprint (only works if you are in the project folder)
ssh -p 2222 -i id_rsa mie@localhost
