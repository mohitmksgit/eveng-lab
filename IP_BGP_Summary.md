# IP Address and BGP Summary

## Management Network Summary
| Device | Management IP | Subnet | Gateway |
|--------|---------------|--------|---------|
| All Devices | 192.168.16.101-130 | /24 | 192.168.16.1 |

## Public IP Allocations

### Customer Networks
- **NAT Prefix:** 23.249.100.0/22
- **CF Specific 1:** 23.249.100.0/23
- **CF Specific 2:** 23.249.102.0/23

### ISP Interconnects
- **ISP-INT01:** 203.0.113.0/30 (.1 ISP, .2 INT01)
- **ISP-INT02:** 203.0.113.4/30 (.5 ISP, .6 INT02)
- **INT01-CF:** 203.0.113.8/30 (.9 INT01, .10 CF)
- **INT02-CF:** 203.0.113.12/30 (.13 INT02, .14 CF)
- **ISP-Firewall:** 203.0.113.16/30 (.17 ISP, .18 FW, .19 HSRP VIP)

### Upstream Provider Links
- **CF-Zayo:** 198.51.100.0/30 (.1 CF, .2 Zayo)
- **CF-Bell:** 198.51.100.4/30 (.5 CF, .6 Bell)
- **Zayo-Equinix:** 198.51.100.8/30 (.9 Zayo, .10 Equinix)
- **Bell-Equinix:** 198.51.100.12/30 (.13 Bell, .14 Equinix)

### Google Network
- **Google-TestServer:** 8.8.8.0/30 (.1 Google, .2 TestServer)

## Private IP Allocations

### Toronto DC Networks
- **LAN VLAN 100:** 10.100.1.0/24 (HSRP .1, N9K01 .2, N9K02 .3, FW .254)
- **Server VLAN 200:** 10.100.2.0/24 (HSRP .1, N9K01 .2, N9K02 .3, FW .254)
- **INT01-N9K01:** 10.100.10.0/30 (.1 INT01, .2 N9K01)
- **INT02-N9K02:** 10.100.10.4/30 (.5 INT02, .6 N9K02)
- **N9K VPC Keepalive:** 10.100.20.0/30 (.1 N9K01, .2 N9K02)

### London Branch
- **London LAN:** 10.40.0.0/24 (.1 London Router)
- **MPLS01-London:** 172.20.1.0/30 (.1 MPLS01, .2 London)
- **MPLS02-London:** 172.20.2.0/30 (.1 MPLS02, .2 London)

### GRE Tunnels
- **Tunnel1 (INT01-CF):** 172.16.1.0/30 (.1 INT01, .2 CF)
- **Tunnel2 (INT01-CF):** 172.16.2.0/30 (.1 INT01, .2 CF)
- **Tunnel3 (INT02-CF):** 172.16.3.0/30 (.1 INT02, .2 CF)
- **Tunnel4 (INT02-CF):** 172.16.4.0/30 (.1 INT02, .2 CF)

## BGP Configuration Summary

### ASN Assignments
| Organization | ASN | Type |
|--------------|-----|------|
| Customer | 65001 | Private |
| Cloudflare | 13335 | Public |
| Bell Canada | 855 | Public |
| Zayo Group | 6461 | Public |
| Equinix | 15830 | Public |
| Google | 15169 | Public |
| MPLS01 | 65100 | Private |
| MPLS02 | 65101 | Private |
| London Branch | 65200 | Private |

### BGP Peering Relationships

#### CF_CE_01 (AS 13335) Peers:
1. **Zayo (AS 6461)** - 198.51.100.2
2. **Bell (AS 855)** - 198.51.100.6
3. **INT01 (AS 65001)** - 172.16.1.1, 172.16.2.1
4. **INT02 (AS 65001)** - 172.16.3.1, 172.16.4.1

#### Equinix (AS 15830) Peers:
1. **Zayo (AS 6461)** - 198.51.100.9
2. **Bell (AS 855)** - 198.51.100.13

#### London Branch (AS 65200) Peers:
1. **MPLS01 (AS 65100)** - 172.20.1.1 (Primary)
2. **MPLS02 (AS 65101)** - 172.20.2.1 (Backup with AS-path prepend)

### Route Advertisements

#### Cloudflare (CF_CE_01) Advertises:
- **1.1.1.1/32** - Cloudflare DNS
- **23.249.100.0/23** - More specific route 1
- **23.249.102.0/23** - More specific route 2
- **203.0.113.10/32** - Tunnel source 1
- **203.0.113.14/32** - Tunnel source 2

#### Equinix Advertises:
- **23.249.100.0/22** - Customer aggregate (less specific)

#### Google (AS 15169) Advertises:
- **8.8.8.8/32** - Google DNS
- **8.8.8.0/30** - Google-TestServer link

#### Customer (INT01/INT02) Advertises:
- **10.100.0.0/16** - Toronto DC networks

#### MPLS Providers Advertise:
- **Default Route (0.0.0.0/0)** to London Branch
- MPLS01: Normal path preference
- MPLS02: Lower preference (AS-path prepend)

## HSRP Configuration

### Active/Standby Setup
| VLAN/Interface | Virtual IP | Active Device | Priority | Standby Device | Priority |
|----------------|------------|---------------|----------|----------------|----------|
| VLAN 100 (LAN) | 10.100.1.1 | N9K01 | 110 | N9K02 | 105 |
| VLAN 200 (Server) | 10.100.2.1 | N9K01 | 110 | N9K02 | 105 |
| ISP-FW Link | 203.0.113.19 | ISP_ROUTER | 110 | - | - |

## VPC Configuration (Nexus 9K)

### VPC Domain 1
- **N9K01 Role Priority:** 100 (Primary)
- **N9K02 Role Priority:** 200 (Secondary)
- **Peer Links:** Port-channel 1 (Eth1/2, Eth1/3)
- **Keepalive:** Eth1/4 (10.100.20.0/30)
- **Features:** Peer-gateway, Peer-switch, Auto-recovery

## Traffic Flow Summary

### Inbound Internet Traffic:
Internet → ISP_ROUTER → HSRP VIP (203.0.113.19) → Palo Alto FW → N9K VPC → End devices

### Outbound Internet Traffic:
End devices → N9K VPC → Palo Alto FW (NAT) → ISP_ROUTER → Internet

### Cloudflare Traffic:
Customer networks ↔ INT01/INT02 ↔ GRE Tunnels ↔ CF_CE_01 ↔ Zayo/Bell → Internet

### London Branch Traffic:
London LAN → London Router → MPLS01 (primary) or MPLS02 (backup) → Internet

## Key Features Implemented

### Redundancy:
- **HSRP** for gateway redundancy
- **VPC** for switch redundancy
- **Multiple BGP paths** for route redundancy
- **Dual MPLS providers** for London branch

### Load Balancing:
- **Multiple GRE tunnels** (4 total)
- **VPC** load balancing across N9K switches
- **BGP multipath** where applicable

### Security:
- **Palo Alto zones** (Internet, Internal, DMZ)
- **NAT** on firewall for internal networks
- **Management ACLs** on all devices

### Optimization:
- **AS-path prepending** for MPLS path preference
- **More specific routes** via Cloudflare for better performance
- **Local preference** configurations for optimal routing