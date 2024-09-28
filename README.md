# docker-sshd-ldap

This is a quick project to test SSHD and LDAP in a Docker container.

## Getting Started

1) Clone the repo
2) Run
```
./test.sh
```


## How it works

1) it makes keys for the server and a test user (named mie)
2) builds docker
3) runs the docker
4) ssh's in to

if you'd like to debug it and see it run in real time, run:
```
docker logs -f sshd-ldap
``` 
 
## Example output

```
% ./test.sh
ssh_server_keys folder not found. Creating folder and generating keys.
Generating public/private rsa key pair.
Your identification has been saved in ./ssh_server_keys/ssh_host_rsa_key
Your public key has been saved in ./ssh_server_keys/ssh_host_rsa_key.pub
The key fingerprint is:
SHA256:6fX85/cafuJ4YRSpqkqBsZjJoPKb/VzamQ2EKq7AFqo horner@MacBook-Air-3.local
The key's randomart image is:
+---[RSA 4096]----+
|               . |
|              o  |
|.   .        . . |
|.o + + . .  . .  |
|o.= o o S .. .   |
|+..  . + ..o  o  |
|ooo . . +.  o... |
|+. = o +.=   +o.+|
|E.+ ..=.+ . .o=*=|
+----[SHA256]-----+
Generating public/private ecdsa key pair.
Your identification has been saved in ./ssh_server_keys/ssh_host_ecdsa_key
Your public key has been saved in ./ssh_server_keys/ssh_host_ecdsa_key.pub
The key fingerprint is:
SHA256:hXE398vOEZN253MGX99UEgsSGx/LoBXepY3Niut3oHM horner@MacBook-Air-3.local
The key's randomart image is:
+---[ECDSA 521]---+
|        . Oo= =..|
|         B X & +o|
|        o + B *=*|
|         . . .o=X|
|        S . .  =B|
|           .. o.+|
|          .. . o |
|         .o E .  |
|          .+ .   |
+----[SHA256]-----+
Generating public/private ed25519 key pair.
Your identification has been saved in ./ssh_server_keys/ssh_host_ed25519_key
Your public key has been saved in ./ssh_server_keys/ssh_host_ed25519_key.pub
The key fingerprint is:
SHA256:qKV5PIoMDKg8Qo944fL0tiY4S7QSR1WgIJATmt1cv7I horner@MacBook-Air-3.local
The key's randomart image is:
+--[ED25519 256]--+
|*o  ooo          |
|=+ = . .         |
|o.+ o   .        |
|..     . .       |
|+oo   + S        |
|O++. * o         |
|BO+.+ E          |
|*Boooo .         |
|.o+++.           |
+----[SHA256]-----+
Keys have been generated.
Generating public/private rsa key pair.
Your identification has been saved in ./id_rsa
Your public key has been saved in ./id_rsa.pub
The key fingerprint is:
SHA256:Auof/5xchQvf7q9pzI4gnSdlHi7g7ONT8L3KVMtSrmg horner@MacBook-Air-3.local
The key's randomart image is:
+---[RSA 4096]----+
|                 |
|                 |
|    .            |
|   . ..    .     |
|  .   ooS.B .    |
| .   o +o&.*     |
|  . . +.O @+.    |
|   . +EB X.o+.   |
|    .o=+O..+*o.  |
+----[SHA256]-----+
[+] Building 1.2s (16/16) FINISHED                                                                                                                                    docker:default
 => [internal] load build definition from Dockerfile                                                                                                                            0.0s
 => => transferring dockerfile: 1.67kB                                                                                                                                          0.0s
 => [internal] load metadata for docker.io/library/debian:latest                                                                                                                0.5s
 => [internal] load .dockerignore                                                                                                                                               0.0s
 => => transferring context: 2B                                                                                                                                                 0.0s
 => [ 1/11] FROM docker.io/library/debian:latest@sha256:27586f4609433f2f49a9157405b473c62c3cb28a581c413393975b4e8496d0ab                                                        0.0s
 => [internal] load build context                                                                                                                                               0.0s
 => => transferring context: 6.96kB                                                                                                                                             0.0s
 => CACHED [ 2/11] RUN apt-get update &&     apt-get install -y openssh-server sssd sssd-ldap ldap-utils sudo net-tools procps traceroute tcpdump &&     apt-get clean && rm -  0.0s
 => CACHED [ 3/11] RUN mkdir /var/run/sshd                                                                                                                                      0.0s
 => [ 4/11] COPY ssh_server_keys/ssh_host_* /etc/ssh/                                                                                                                           0.0s
 => [ 5/11] RUN useradd -m -s /bin/bash mie &&     usermod -aG sudo mie                                                                                                         0.1s
 => [ 6/11] RUN echo 'mie ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers                                                                                                               0.1s
 => [ 7/11] RUN sed -i 's/#Port 22/Port 2222/' /etc/ssh/sshd_config &&     sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config                0.1s
 => [ 8/11] COPY id_rsa.pub /home/mie/.ssh/authorized_keys                                                                                                                      0.0s
 => [ 9/11] RUN chown -R mie:mie /home/mie/.ssh && chmod 600 /home/mie/.ssh/authorized_keys                                                                                     0.1s
 => [10/11] COPY configure-ldap.sh /usr/local/bin/configure-ldap.sh                                                                                                             0.0s
 => [11/11] RUN chmod +x /usr/local/bin/configure-ldap.sh                                                                                                                       0.1s
 => exporting to image                                                                                                                                                          0.0s
 => => exporting layers                                                                                                                                                         0.0s
 => => writing image sha256:6720d93a85723fc414a1948836ffc1da28ccbf1767787cadd1cea13528fbc18b                                                                                    0.0s
 => => naming to docker.io/library/sshd-ldap                                                                                                                                    0.0s

View build details: docker-desktop://dashboard/build/default/default/u243tphekrmha7skiqj37ph09

 2 warnings found (use docker --debug to expand):
 - LegacyKeyValueFormat: "ENV key=value" should be used instead of legacy "ENV key value" format (line 6)
 - LegacyKeyValueFormat: "ENV key=value" should be used instead of legacy "ENV key value" format (line 7)
sshd-ldap
127e707d3e1be1d33c392e919812881226f2ff073d67c42e9436fc1cd998c799
The authenticity of host '[localhost]:2222 ([::1]:2222)' can't be established.
ED25519 key fingerprint is SHA256:qKV5PIoMDKg8Qo944fL0tiY4S7QSR1WgIJATmt1cv7I.
This key is not known by any other names.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '[localhost]:2222' (ED25519) to the list of known hosts.
Linux 127e707d3e1b 6.10.4-linuxkit #1 SMP Mon Aug 12 08:47:01 UTC 2024 aarch64

The programs included with the Debian GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.
mie@127e707d3e1b:~$
```

## Cleanup

Run the clean script to clean up the keys and fingerprints.
```
./clean.sh
```

## Credits

Thank you GPT for your fast typing and noodging: https://chatgpt.com/share/66f78b40-3f7c-8004-aecf-de23bc440e80
