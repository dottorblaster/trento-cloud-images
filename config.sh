#!/bin/bash
#================
# FILE          : config.sh
#----------------
# PROJECT       : OpenSuSE KIWI Image System
# COPYRIGHT     : (c) 2006 SUSE LINUX Products GmbH. All rights reserved
#               :
# AUTHOR        : Marcus Schaefer <ms@suse.de>
#               :
# BELONGS TO    : Operating System images
#               :
# DESCRIPTION   : configuration script for SUSE based
#               : operating systems
#               :
#               :
# STATUS        : BETA
#----------------
#======================================
# Functions...
#--------------------------------------
test -f /.kconfig && . /.kconfig
test -f /.profile && . /.profile

#======================================
# Greeting...
#--------------------------------------
echo "Configure image: [$kiwi_iname]..."

#======================================
# Setup baseproduct link
#--------------------------------------
suseSetupProduct

#======================================
# Activate services
#--------------------------------------
suseInsertService sshd
suseInsertService grub_config
suseInsertService dracut_hostonly
suseInsertService docker

#======================================
# Setup default target, multi-user
#--------------------------------------
baseSetRunlevel 3

ansible-galaxy collection install community.general
ansible-galaxy collection install community.docker
ansible-galaxy collection install community.postgresql
ansible-galaxy collection install community.rabbitmq

git clone https://github.com/CDimonaco/trento-ansible.git 
cd trento-ansible
ansible-playbook -e web_postgres_password="pass" -e wanda_postgres_password="wanda" -e rabbitmq_password="trento" -e runner_url="http://localhost" -e grafana_api_url="http://host.docker.internal:3000/api" -e prometheus_url="http://localhost" -e web_admin_password="adminpassword" -e trento_server_name="trento.local trento.local:8080" playbook.yml
