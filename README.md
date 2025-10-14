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

## Installation and Usage

### Prerequisites
```bash
# Install Ansible collections
ansible-galaxy collection install -r requirements.yml

# Create vault file for passwords
ansible-vault create group_vars/all/vault.yml
```

### Running the Playbook
```bash
# Deploy all configurations
ansible-playbook site.yml --ask-vault-pass

# Deploy specific group
ansible-playbook site.yml --limit cisco_ios --ask-vault-pass
ansible-playbook site.yml --limit cisco_nxos --ask-vault-pass
ansible-playbook site.yml --limit palo_alto --ask-vault-pass
```

### Verification Commands

#### Cisco IOS/NXOS
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
```

#### Palo Alto
```bash
# Interface Status
show interface all

# NAT Policy
show running nat-policy

# Zone Configuration
show zone all
```

## Notes
- All devices use SSH for management access
- Management access restricted to 192.168.16.0/24 network
- BGP route preferences configured for optimal traffic flow
- Redundancy provided through HSRP, VPC, and multiple BGP paths