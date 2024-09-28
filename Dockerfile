# Start from the official Debian image
FROM debian:latest

# Set environment variables with default values
ENV DEBIAN_FRONTEND=noninteractive
ENV HOSTNAME ssh
ENV DOMAIN_NAME example.com

# Install necessary packages: ssh, sssd, ldap-utils, sudo, and networking tools
RUN apt-get update && \
    apt-get install -y openssh-server sssd sssd-ldap ldap-utils sudo net-tools procps traceroute tcpdump && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Create SSH directory and generate SSH keys
RUN mkdir /var/run/sshd && \
    ssh-keygen -A

# Create a fallback user 'mie' with password 'mie' and add to sudoers
RUN useradd -m -s /bin/bash mie && \
    echo 'mie:mie' | chpasswd && \
    usermod -aG sudo mie

# (Optional) Allow 'mie' to use sudo without a password
RUN echo 'mie ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Configure SSH to use a non-privileged port (e.g., 2222) and enable password authentication
RUN sed -i 's/#Port 22/Port 2222/' /etc/ssh/sshd_config && \
    sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Copy a script to configure LDAP and hostname
COPY configure-ldap.sh /usr/local/bin/configure-ldap.sh
RUN chmod +x /usr/local/bin/configure-ldap.sh

# Expose the non-privileged SSH port
EXPOSE 2222

# Start SSH, configure LDAP, and sssd services
CMD ["/bin/bash", "-c", "/usr/local/bin/configure-ldap.sh && /usr/sbin/sshd && /usr/sbin/sssd -i -d3"]

