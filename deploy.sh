#!/bin/bash

# Network Deployment Script
echo "Starting Network Configuration Deployment..."

# Check if vault file exists
if [ ! -f "group_vars/all/vault.yml" ]; then
    echo "Creating vault file from example..."
    cp group_vars/all/vault_example.yml group_vars/all/vault.yml
    echo "Please edit group_vars/all/vault.yml with your passwords"
    echo "Then encrypt it with: ansible-vault encrypt group_vars/all/vault.yml"
    exit 1
fi

# Install required collections
echo "Installing Ansible collections..."
ansible-galaxy collection install -r requirements.yml

# Validate inventory
echo "Validating inventory..."
ansible-inventory --list > /dev/null
if [ $? -ne 0 ]; then
    echo "Inventory validation failed!"
    exit 1
fi

# Deploy configurations
echo "Deploying configurations..."
echo "1. Deploying Cisco IOS devices..."
ansible-playbook site.yml --limit cisco_ios --ask-vault-pass

echo "2. Deploying Cisco NXOS devices..."
ansible-playbook site.yml --limit cisco_nxos --ask-vault-pass

echo "3. Deploying Palo Alto firewall..."
ansible-playbook site.yml --limit palo_alto --ask-vault-pass

echo "Deployment completed!"

# Verification
echo "Running basic connectivity tests..."
ansible all -m ping --ask-vault-pass

echo "Network deployment script finished!"