#!/bin/bash

set -x

RED='\033[0;32m'
NC='\033[0m'


# Check permission

if [ "$EUID" -ne 0 ]
  then echo -e "${RED}Please run as root (SUDO)${NC}"
  exit
fi







# update yum
echo -e "${RED}UPDATE YUM${NC}"
sudo yum update -y

