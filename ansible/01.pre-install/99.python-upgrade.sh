#!/bin/bash
yum install -y https://centos7.iuscommunity.org/ius-release.rpm

yum install -y python36u python36u-libs python36u-devel python36u-pip

cd /usr/bin
mv python python_backup
ln -s python3.6 python

python -V

find /usr/bin -name yum -exec sed -i 's/python/python2.7/g' {} \;
find /usr/libexec -name urlgrabber-ext-down -exec sed -i 's/python/python2.7/g' {} \;
