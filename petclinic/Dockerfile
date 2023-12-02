# Use the official Ubuntu base image
FROM ubuntu:latest

# Update the package list
RUN apt-get update -y

# Install SSH
RUN apt-get update && apt-get install -y openssh-server
RUN mkdir /var/run/sshd

RUN apt-get update && apt-get install -y openjdk-17-jdk

# create a user and set password
RUN useradd -m ansible && yes password | passwd ansible

# Start a process that will keep the container running
CMD ["/usr/sbin/sshd", "-D"]