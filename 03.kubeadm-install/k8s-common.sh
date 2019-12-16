#!/bin/bash

set -x

GREEN='\033[0;32m'
NC='\033[0m'


# Check permission
if [ "$EUID" -ne 0 ]
  then echo -e "${GREEN}Please run as root (SUDO)${NC}"
  exit
fi


# Stop Firewalld
echo -e "${GREEN}TURN OFF FIREWALLD${NC}"
systemctl stop firewalld
systemctl disable firewalld


# uninstall old version docker
#echo -e "${GREEN}REMOVING OLD VERSION DOCKER${NC}"
#sudo yum remove -y docker \
#docker-client \
#docker-client-latest \
#docker-common \
#docker-latest \
#docker-latest-logrotate \
#docker-logrotate \
#docker-selinux \
#docker-engine-selinux \
#docker-engine


## Install Required Packages
echo -e "${GREEN}INSTALL REQUIGREEN PACKAGES${NC}"
yum install -y yum-utils \
device-mapper-persistent-data \
lvm2


## Setup Repository
#echo -e "${GREEN}SETUP REPOSITORY${NC}"
#yum-config-manager \
#--add-repo \
#https://download.docker.com/linux/centos/docker-ce.repo


# Install Docker
#echo -e "${GREEN}INSTALL DOCKER${NC}"
#yum install -y docker-ce


# Start Docker
#echo -e "${GREEN}START DOCKER${NC}"
#systemctl start docker
#systemctl enable docker


# Add User To Docker Group
#echo -e "${GREEN}ADD CURRENT USER INTO DOCKER GROUP${NC}"
#/sbin/usermod -aG docker $USER


# Change Cgroup Driver
echo -e "${GREEN}Change Cgroup Driver${NC}
mkdir /etc/docker

mkdir -p /etc/systemd/system/docker.server.d
systemctl daemon-reload
systemctl restart docker


#========================================================================================================================#


# INSTALL KUBERNETES
echo -e "${GREEN}INSTALL KUBERNETES${NC}"
bash -c 'cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=0
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kube*
EOF'


# Disable Security Linux
echo -e "${GREEN}TURN OFF SELINUX${NC}"
/sbin/setenforce 0
/usr/bin/sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config


# Disable SWAP
echo -e "${GREEN}DISABLE SWAP${NC}"
/sbin/swapoff -a


# Set IP Forward
echo -e "${GREEN}SET IP FORWARDING${NC}"
echo -e 1 > sudo /proc/sys/net/ipv4/ip_forward


# Network Setting
echo -e "${GREEN}SET NETWORK CONFIGURATION${NC}"
bash -c 'cat <<EOF > /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF'
sysctl --system


# Install Kubernetes
echo -e "${GREEN}INSTALL KUBERNETES${NC}"
/usr/bin/yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes


# Start kubelet
echo -e "${GREEN}START KUBELET${NC}"
systemctl daemon-reload
systemctl restart kubelet
systemctl enable kubelet
