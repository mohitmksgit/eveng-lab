# Network Topology Documentation

## Overview
This document describes the complete network topology configuration for the lab environment including Toronto DC, London Branch, and various ISP connections with Cloudflare integration.

## Management Network
- **Range:** 192.168.16.0/24
- **Gateway:** 192.168.16.1
- **Device Range:** 192.168.16.101-150

## Device Management IP Assignments

### Cisco IOS Routers
| Device | Management IP | Interface | Description |
|--------|---------------|-----------|-------------|
| ISP_ROUTER | 192.168.16.101 | ethernet0/0 | ISP Edge Router |
| INT01 | 192.168.16.102 | ethernet0/0 | Internet Router 1 |
| INT02 | 192.168.16.103 | ethernet0/0 | Internet Router 2 |
| CF_CE_01 | 192.168.16.104 | ethernet0/0 | Cloudflare CE Router |
| MPLS01 | 192.168.16.105 | ethernet0/0 | MPLS Provider 1 |
| MPLS02 | 192.168.16.106 | ethernet0/0 | MPLS Provider 2 |
| LONDON_BRANCH | 192.168.16.107 | ethernet0/0 | London Branch Router |
| ZAYO | 192.168.16.108 | ethernet0/0 | Zayo ISP Router |
| BELL | 192.168.16.109 | ethernet0/0 | Bell ISP Router |
| EQUINIX | 192.168.16.110 | ethernet0/0 | Equinix Router |
| GOOGLE_PE | 192.168.16.111 | ethernet0/0 | Google PE Router |
| TEST_SERVER | 192.168.16.112 | ethernet0/0 | Test Server |

### Cisco NXOS Switches
| Device | Management IP | Interface | Description |
|--------|---------------|-----------|-------------|
| N9K01 | 192.168.16.120 | mgmt0 | Nexus 9K Switch 1 |
| N9K02 | 192.168.16.121 | mgmt0 | Nexus 9K Switch 2 |

### Palo Alto Firewall
| Device | Management IP | Description |
|--------|---------------|-------------|
| PALO_ALTO_FW | 192.168.16.130 | Palo Alto Firewall |

## Network Subnets

### Toronto DC Networks
- **LAN Network:** 10.100.1.0/24 (VLAN 100)
- **Server Network:** 10.100.2.0/24 (VLAN 200)
- **Transit Networks:** 10.100.x.x/30 for point-to-point links

### London Branch Networks
- **LAN Network:** 10.40.0.0/24

### Public IP Ranges
- **Customer NAT Prefix:** 23.249.100.0/22
- **Cloudflare Specific Routes:**
  - 23.249.100.0/23
  - 23.249.102.0/23

### Point-to-Point Links
| Link | Network | Description |
|------|---------|-------------|
| ISP_ROUTER ↔ INT01 | 203.0.113.0/30 | ISP to INT01 |
| ISP_ROUTER ↔ INT02 | 203.0.113.4/30 | ISP to INT02 |
| INT01 ↔ CF_CE_01 | 203.0.113.8/30 | INT01 to Cloudflare |
| INT02 ↔ CF_CE_01 | 203.0.113.12/30 | INT02 to Cloudflare |
| CF_CE_01 ↔ ZAYO | 198.51.100.0/30 | Cloudflare to Zayo |
| CF_CE_01 ↔ BELL | 198.51.100.4/30 | Cloudflare to Bell |
| ZAYO ↔ EQUINIX | 198.51.100.8/30 | Zayo to Equinix |
| BELL ↔ EQUINIX | 198.51.100.12/30 | Bell to Equinix |
| GOOGLE_PE ↔ TEST_SERVER | 8.8.8.0/30 | Google to Test Server |
| INT01 ↔ N9K01 | 10.100.10.0/30 | INT01 to N9K01 |
| INT02 ↔ N9K02 | 10.100.10.4/30 | INT02 to N9K02 |
| N9K01 ↔ N9K02 (Keepalive) | 10.100.20.0/30 | VPC Keepalive |
| MPLS01 ↔ LONDON_BRANCH | 172.20.1.0/30 | MPLS01 to London |
| MPLS02 ↔ LONDON_BRANCH | 172.20.2.0/30 | MPLS02 to London |

## GRE Tunnels

### Tunnel Configuration
| Tunnel | Source | Destination | Network | Description |
|--------|--------|-------------|---------|-------------|
| Tunnel1 | INT01 (203.0.113.9) | CF_CE_01 (203.0.113.10) | 172.16.1.0/30 | INT01 to CF Tunnel 1 |
| Tunnel2 | INT01 (203.0.113.9) | CF_CE_01 (203.0.113.14) | 172.16.2.0/30 | INT01 to CF Tunnel 2 |
| Tunnel3 | INT02 (203.0.113.13) | CF_CE_01 (203.0.113.10) | 172.16.3.0/30 | INT02 to CF Tunnel 3 |
| Tunnel4 | INT02 (203.0.113.13) | CF_CE_01 (203.0.113.14) | 172.16.4.0/30 | INT02 to CF Tunnel 4 |

## BGP Configuration

### ASN Assignments
| Organization | ASN | Description |
|--------------|-----|-------------|
| Customer | 65001 | Customer ASN |
| Cloudflare | 13335 | Cloudflare ASN |
| Bell | 855 | Bell Canada |
| Zayo | 6461 | Zayo Group |
| Equinix | 15830 | Equinix ASN |
| Google | 15169 | Google ASN |
| MPLS01 | 65100 | MPLS Provider 1 |
| MPLS02 | 65101 | MPLS Provider 2 |
| London Branch | 65200 | London Branch |

### BGP Peering
- **CF_CE_01** peers with:
  - Zayo (198.51.100.2)
  - Bell (198.51.100.6)
  - INT01 via Tunnels 1 & 2
  - INT02 via Tunnels 3 & 4

- **Route Advertisements:**
  - Equinix advertises 23.249.100.0/22 to upstream providers
  - Cloudflare advertises more specific routes (23.249.100.0/23, 23.249.102.0/23)
  - MPLS01 preferred path (lower AS-path)
  - MPLS02 backup path (AS-path prepending)

## HSRP Configuration

### Virtual IP Assignments
| VLAN/Interface | Virtual IP | Primary | Secondary | Description |
|----------------|------------|---------|-----------|-------------|
| N9K VLAN 100 | 10.100.1.1 | N9K01 (110) | N9K02 (105) | LAN Gateway |
| N9K VLAN 200 | 10.100.2.1 | N9K01 (110) | N9K02 (105) | Server Gateway |
| ISP-FW Link | 203.0.113.19 | ISP_ROUTER (110) | - | Firewall Gateway |

## VPC Configuration (Nexus 9K)

### N9K01 & N9K02 VPC Setup
- **Domain ID:** 1
- **Peer Links:** Ethernet1/2, Ethernet1/3 (Port-channel 1)
- **Keepalive:** Ethernet1/4 (10.100.20.0/30)
- **Peer-Gateway:** Enabled
- **Peer-Switch:** Enabled
- **Auto-Recovery:** Enabled

## Palo Alto Firewall Zones

### Zone Configuration
| Zone | Interface | Network | Description |
|------|-----------|---------|-------------|
| Internet | ethernet1/1 | 203.0.113.18/30 | External Internet |
| Internal | ethernet1/2 | 10.100.1.254/24 | LAN Network |
| DMZ | ethernet1/3 | 10.100.2.254/24 | Server Network |

### NAT Configuration
- **Source NAT:** Internal/DMZ → Internet
- **Translation:** Dynamic IP and Port
- **Interface:** ethernet1/1

## Loopback Addresses

### Special Loopbacks
| Device | Loopback | IP Address | Purpose |
|--------|----------|------------|---------|
| CF_CE_01 | Loopback1 | 203.0.113.10/32 | Tunnel Source 1 |
| CF_CE_01 | Loopback2 | 203.0.113.14/32 | Tunnel Source 2 |
| CF_CE_01 | Loopback100 | 1.1.1.1/32 | Cloudflare Public IP |
| GOOGLE_PE | Loopback0 | 8.8.8.8/32 | Google DNS |

## Static Routes

### Key Static Routes
- **ISP_ROUTER:** 23.249.100.0/22 → 203.0.113.19 (HSRP VIP)
- **INT01/INT02:** Customer networks → N9K switches
- **LONDON_BRANCH:** Default via MPLS01 (preferred) and MPLS02 (backup)

## Repository Overview

This is an **EVE-NG Network Lab** repository that automates the configuration of a complex multi-vendor network topology using Ansible. It includes:

- **Cisco IOS/IOS-XE routers** (ISP, MPLS, Branch routers)
- **Cisco Nexus 9K switches** (Data center switches with VPC)
- **Palo Alto firewalls**
- **BGP routing** with multiple ASNs
- **GRE tunnels** for Cloudflare integration
- **HSRP** for high availability

## Prerequisites

1. **EVE-NG** environment with the network topology deployed
2. **Ansible** installed on your control machine (version 2.9+)
3. **Python** with network automation libraries
4. **SSH access** to all network devices on management network (192.168.16.0/24)

## Setup Instructions

### 1. Install Required Ansible Collections

```bash
# Install the required Ansible collections
ansible-galaxy collection install -r requirements.yml
```

### 2. Set Up Ansible Vault (CRITICAL STEP)

The vault stores sensitive information like device passwords. Here's how to set it up:

#### Option A: Create new vault file
```bash
# Create encrypted vault file
ansible-vault create group_vars/all/vault.yml
```

When prompted, enter a vault password (remember this!). Then add your device credentials:

```yaml
---
# Device authentication
vault_username: "admin"
vault_password: "YourDevicePassword123!"
vault_enable_password: "YourEnablePassword123!"

# Device-specific passwords (if different)
device_passwords:
  cisco_ios: "cisco123"
  cisco_nxos: "admin123" 
  palo_alto: "paloalto123"

# SNMP community strings
vault_snmp_community: "YourSNMPCommunity"
```

#### Option B: Use the example file as template
```bash
# Copy the example and encrypt it
cp group_vars/all/vault_example.yml group_vars/all/vault.yml
ansible-vault encrypt group_vars/all/vault.yml
```

### 3. Verify Your Inventory

Check that your device management IPs match your EVE-NG topology:

```bash
# View inventory
cat inventory.yml

# Test connectivity to all devices
ansible all -m ping --ask-vault-pass
```

### 4. Deploy Configurations

#### Deploy to all devices:
```bash
ansible-playbook site.yml --ask-vault-pass
```

#### Deploy to specific device groups:
```bash
# Cisco IOS routers only
ansible-playbook site.yml --limit cisco_ios --ask-vault-pass

# Cisco switches only  
ansible-playbook site.yml --limit cisco_switches --ask-vault-pass

# Palo Alto firewall only
ansible-playbook site.yml --limit palo_alto --ask-vault-pass

# Single device
ansible-playbook site.yml --limit ISP_ROUTER --ask-vault-pass
```

## Vault Management Commands

```bash
# Edit existing vault
ansible-vault edit group_vars/all/vault.yml

# View vault contents (decrypted)
ansible-vault view group_vars/all/vault.yml

# Change vault password
ansible-vault rekey group_vars/all/vault.yml

# Decrypt vault (not recommended for production)
ansible-vault decrypt group_vars/all/vault.yml

# Encrypt an existing file
ansible-vault encrypt group_vars/all/vault.yml
```

### Verification Commands

#### Post-Deployment Verification
After deployment, verify configurations using these commands:

```bash
# Check BGP status on all IOS devices
ansible cisco_ios -a "show ip bgp summary" --ask-vault-pass

# Check interface status on all devices
ansible cisco_ios -a "show ip interface brief" --ask-vault-pass

# Check routing tables
ansible cisco_ios -a "show ip route bgp" --ask-vault-pass

# Check HSRP status on switches
ansible cisco_switches -a "show hsrp brief" --ask-vault-pass

# Check VPC status on Nexus switches
ansible cisco_switches -a "show vpc" --ask-vault-pass

# Check tunnel status
ansible cisco_ios -a "show interface tunnel" --ask-vault-pass
```

#### Manual Device Verification Commands

##### Cisco IOS/NXOS
```bash
# BGP Status
show ip bgp summary
show ip bgp

# Interface Status
show ip interface brief

# Routing Table
show ip route

# HSRP Status (NXOS)
show hsrp brief

# VPC Status (NXOS)
show vpc

# GRE Tunnel Status
show interface tunnel
show ip route static
```

##### Palo Alto
```bash
# Interface Status
show interface all

# NAT Policy
show running nat-policy

# Zone Configuration
show zone all

# Route Table
show routing route
```

## Troubleshooting

### Common Issues and Solutions

1. **Authentication Failures**
   - Verify vault password: `ansible-vault view group_vars/all/vault.yml`
   - Check device credentials and enable passwords
   - Ensure SSH access to management network (192.168.16.0/24)

2. **Connection Timeouts**
   - Verify device management IP addresses in inventory.yml
   - Check network connectivity: `ping <device_management_ip>`
   - Verify SSH service is running on devices

3. **Template Errors**
   - Review Jinja2 templates in `templates/` directory
   - Check variable definitions in `vars/` directory
   - Validate YAML syntax: `ansible-playbook site.yml --syntax-check`

4. **BGP Issues**
   - Verify ASN assignments in inventory.yml
   - Check BGP neighbor configurations in templates
   - Validate IP addressing and routing

5. **HSRP/VPC Issues**
   - Check priority settings and preemption
   - Verify keepalive links and peer configurations
   - Validate VLAN configurations

## Network Topology Quick Reference

### Key Networks
- **Management**: 192.168.16.0/24
- **Customer LAN**: 10.100.1.0/24 (VLAN 100)
- **Server Network**: 10.100.2.0/24 (VLAN 200)
- **Public NAT Range**: 23.249.100.0/22
- **GRE Tunnels**: 172.16.1.0/30 - 172.16.4.0/30

### ASN Summary
| Organization | ASN | Role |
|--------------|-----|------|
| Customer | 65001 | Main customer network |
| Cloudflare | 13335 | CDN provider |
| Bell Canada | 855 | ISP provider |
| Zayo | 6461 | Fiber provider |
| Google | 15169 | Public cloud |
| MPLS Providers | 65100/65101 | WAN connectivity |

## Security Best Practices

1. **Vault Security**
   - Never commit unencrypted passwords to version control
   - Use strong, unique vault passwords
   - Store vault passwords in secure password managers
   - Regularly rotate device credentials

2. **Access Control**
   - Limit Ansible control machine access
   - Use SSH keys where possible
   - Implement network segmentation for management traffic
   - Regular security audits of device configurations

3. **Change Management**
   - Test configurations in development environment first
   - Use version control for all configuration changes
   - Implement rollback procedures
   - Document all network changes

## File Structure

```
eveng-lab/
├── ansible.cfg              # Ansible configuration
├── inventory.yml            # Device inventory and groups
├── site.yml                # Main playbook
├── requirements.yml         # Ansible collection requirements
├── group_vars/all/
│   └── vault.yml           # Encrypted credentials (create this)
├── vars/
│   ├── network_vars.yml    # Network variables
│   ├── interface_mapping.yml # Interface mappings
│   └── mgmt_ips.yml       # Management IP assignments
├── tasks/
│   ├── ios_config.yml     # IOS configuration tasks
│   ├── nxos_config.yml    # NXOS configuration tasks
│   └── panos_config.yml   # Palo Alto configuration tasks
└── templates/
    ├── *.j2               # Jinja2 configuration templates
    └── ...                # Device-specific templates
```

## Quick Start Guide

### For New Users

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd eveng-lab
   ```

2. **Install dependencies**
   ```bash
   ansible-galaxy collection install -r requirements.yml
   ```

3. **Create vault with your credentials**
   ```bash
   ansible-vault create group_vars/all/vault.yml
   # Add your device passwords when prompted
   ```

4. **Test connectivity**
   ```bash
   ansible all -m ping --ask-vault-pass
   ```

5. **Deploy configuration**
   ```bash
   ansible-playbook site.yml --ask-vault-pass
   ```

### For Experienced Users

- Modify `inventory.yml` for your specific EVE-NG topology
- Customize templates in `templates/` directory
- Adjust variables in `vars/` directory
- Use `--limit` flag for targeted deployments
- Implement additional verification tasks as needed

## Notes
- All devices use SSH for management access
- Management access restricted to 192.168.16.0/24 network
- BGP route preferences configured for optimal traffic flow
- Redundancy provided through HSRP, VPC, and multiple BGP paths