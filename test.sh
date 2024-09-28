#!/bin/bash

./makekeys.sh
docker build -t sshd-ldap .
docker rm -f sshd-ldap; docker run -d --name sshd-ldap -p 2222:2222 -e HOSTNAME=doug -e DOMAIN_NAME=mieweb.com sshd-ldap

# test the ssh connection and accpet the fingerprint
ssh -p 2222 -i id_rsa mie@localhost
