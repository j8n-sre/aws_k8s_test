#!/bin/bash

set -e
set -x

# Check permission
if [ "$EUID" -ne 0 ]
  then echo -e "Please run as root (SUDO)"
  exit
fi


# INSTALL KUBERNETES
echo -e "INSTALL KUBERNETES"
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
#echo -e "TURN OFF SELINUX"
#/sbin/setenforce 0
#/usr/bin/sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config


# Disable SWAP
echo -e "DISABLE SWAP"
/sbin/swapoff -a
/usr/bin/sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab


# Set IP Forward
echo -e "SET IP FORWARDING"
echo -e 1 > sudo /proc/sys/net/ipv4/ip_forward


# Network Setting
echo -e "SET NETWORK CONFIGURATION"
bash -c 'cat <<EOF > /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF'
sysctl --system


# Install Kubernetes
echo -e "INSTALL KUBERNETES"
yum install -y kubelet=1.16.4-00 kubeadm=1.16.4-00 kubectl=1.16.4-00 --disableexcludes=kubernetes


# Start kubelet
echo -e "START KUBELET"
systemctl daemon-reload
systemctl restart kubelet
systemctl enable kubelet
