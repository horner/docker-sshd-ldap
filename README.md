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
 
