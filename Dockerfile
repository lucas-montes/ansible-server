# Use the official Ubuntu base image with a specified version (e.g., 20.04)
FROM ubuntu:20.04

# Install SSH server and update the package list
RUN apt-get update && apt-get install -y openssh-server && apt-get clean

# Create a new SSH key (uncomment this line if you want to use a specific key)
# RUN ssh-keygen -A

# Set a password for the root user (change 'password' to your desired password)
RUN echo 'root:password' | chpasswd

# Enable password authentication (you may want to use key-based authentication instead)
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# By default, Docker does not allocate a pseudo-TTY, which is required for SSH to work.
# The following line ensures SSH works properly.
RUN mkdir /run/sshd

# Expose SSH port (port 22) to allow SSH connections
EXPOSE 22

# Start the SSH service when the container starts
CMD ["/usr/sbin/sshd", "-D"]
