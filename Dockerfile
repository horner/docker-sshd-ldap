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

# Create SSH directory
RUN mkdir /var/run/sshd

# Copy SSH server keys from the local directory into the container
COPY ssh_server_keys/ssh_host_* /etc/ssh/

# Create a fallback user 'mie' and add to sudoers
RUN useradd -m -s /bin/bash mie && \
    usermod -aG sudo mie

# (Optional) Allow 'mie' to use sudo without a password
RUN echo 'mie ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Configure SSH to use a non-privileged port (e.g., 2222) and disable password authentication
RUN sed -i 's/#Port 22/Port 2222/' /etc/ssh/sshd_config && \
    sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config

# Copy the public key into the container and set up SSH access for 'mie'
COPY id_rsa.pub /home/mie/.ssh/authorized_keys
RUN chown -R mie:mie /home/mie/.ssh && chmod 600 /home/mie/.ssh/authorized_keys

# Copy a script to configure LDAP and hostname
COPY configure-ldap.sh /usr/local/bin/configure-ldap.sh
RUN chmod +x /usr/local/bin/configure-ldap.sh

# Expose the non-privileged SSH port
EXPOSE 2222

# Start SSH, configure LDAP, and sssd services
CMD ["/bin/bash", "-c", "/usr/local/bin/configure-ldap.sh && /usr/sbin/sshd && /usr/sbin/sssd -i -d3"]

