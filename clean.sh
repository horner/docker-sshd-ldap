#!/bin/bash

ssh-keygen -R "[localhost]:2222"
rm -rf ssh_server_keys
rm id_rsa.pub id_rsa
