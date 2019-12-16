#!/bin/bash
rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum -y install ansible

echo ""
echo "Ansible --version"
ansible --version

find /etc/ansible -name ansible.cfg -exec sed -i 's/#log_path/log_path/g' {} \;
