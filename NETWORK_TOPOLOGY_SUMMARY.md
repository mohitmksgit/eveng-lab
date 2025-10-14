# 🌐 **NETWORK TOPOLOGY SUMMARY**

## 📊 **Network Overview:**

### **🏢 Enterprise Multi-Site Architecture**
- **Primary Site:** Toronto DC (10.100.x.x)
- **Branch Site:** London Office (10.40.x.x) 
- **Internet Connectivity:** Dual-path with redundancy
- **Security:** PaloAlto firewall with zone-based policies
- **Providers:** Cloudflare, Bell, Google, Zayo connectivity

---

## 🎯 **CORE NETWORK TOPOLOGY**

```
                    ┌─────────────────── INTERNET ───────────────────┐
                    │                                                │
         ┌──────────▼──────────┐                          ┌────────▼────────┐
         │   Google_PE01       │                          │   Zayo_Router_01│
         │   AS 15169          │                          │   AS 6461       │
         │   8.8.8.8 (DNS)     │                          │                 │
         └──────────┬──────────┘                          └────────┬────────┘
                    │                                              │
         ┌──────────▼──────────┐                          ┌────────▼────────┐
         │   Bell_Router_01    │◄─────────────────────────►│ Cloudflare_PE01 │
         │   AS 577            │   198.51.100.4/30        │   AS 13335      │
         │                     │                          │   (Primary CDN) │
         └──────────┬──────────┘                          └────────┬────────┘
                    │                                              │
                    │                                              │
         ┌──────────▼──────────┐                          ┌────────▼────────┐
         │    ISP_ROUTER       │◄─────── 4 GRE Tunnels ──┘   172.16.x.x/30
         │   (Equinix)         │          (Backup Path)
         │   AS 15830          │
         └──────────┬──────────┘
                    │ 
                    │ 10.100.100.0/29 (HSRP Group 10)
                    │ VIP: 10.100.100.1
         ┌──────────▼──────────┐
         │  INT01 ◄──iBGP──► INT02  │
         │  AS 62881     AS 62881   │
         │  (Active)     (Standby) │
         └──────────┬──────────────┘
                    │
                    │ 10.100.200.0/29 (HSRP Group 20)
                    │ VIP: 10.100.200.1
         ┌──────────▼──────────┐
         │     PaloAlto FW     │
         │   Security Zones    │
         │   (NAT Gateway)     │
         └──────────┬──────────┘
                    │
         ┌──────────▼──────────┐        ┌─────────────────┐
         │   L2_DC_SW01/02     │        │    MPLS Cloud   │
         │   (Core Switches)   │        │   MPLS01/MPLS02 │
         └──────────┬──────────┘        │   AS 65001      │
                    │                   └─────────┬───────┘
         ┌──────────▼──────────┐                  │
         │  Toronto DC LANs    │                  │
         │  10.100.1.0/24 (LAN)│         ┌────────▼────────┐
         │  10.100.2.0/24 (SRV)│         │ London_Router_01│
         └─────────────────────┘         │   AS 65300      │
                                         │  10.40.0.0/24   │
                                         └─────────────────┘
```

---

## 🔧 **DEVICE INVENTORY**

### **🌐 Core Infrastructure:**
| Device | ASN | Management IP | Role |
|--------|-----|---------------|------|
| **ISP_ROUTER** | 15830 | 192.168.16.101 | Equinix Internet Gateway |
| **INT01** | 62881 | 192.168.16.102 | Core Router (Primary) |
| **INT02** | 62881 | 192.168.16.103 | Core Router (Backup) |
| **PaloAlto** | N/A | 192.168.16.130 | Security Firewall |

### **🏢 Data Center:**
| Device | ASN | Management IP | Role |
|--------|-----|---------------|------|
| **L2_DC_SW01** | N/A | 192.168.16.120 | Core Switch (VLAN 100) |
| **L2_DC_SW02** | N/A | 192.168.16.121 | Core Switch (VLAN 200) |
| **Server_Test** | N/A | 192.168.16.108 | Test Server |

### **🌍 Provider Edge:**
| Device | ASN | Management IP | Provider |
|--------|-----|---------------|----------|
| **Cloudflare_PE01** | 13335 | 192.168.16.104 | Cloudflare CDN |
| **Zayo_Router_01** | 6461 | 192.168.16.105 | Zayo Communications |
| **Bell_Router_01** | 577 | 192.168.16.106 | Bell Canada |
| **Google_PE01** | 15169 | 192.168.16.107 | Google Cloud |

### **🏢 Branch & MPLS:**
| Device | ASN | Management IP | Location |
|--------|-----|---------------|----------|
| **London_Router_01** | 65300 | 192.168.16.111 | London Branch |
| **MPLS01** | 65001 | 192.168.16.109 | MPLS Provider |
| **MPLS02** | 65001 | 192.168.16.110 | MPLS Provider |

---

## 🔗 **CONNECTIVITY MATRIX**

### **🎯 Primary Internet Path:**
```
Customer LANs → PaloAlto → INT01/INT02 → ISP_Router → Internet
```

### **🔄 Backup CDN Path:**
```
Customer LANs → PaloAlto → INT01/INT02 → GRE Tunnels → Cloudflare_PE01 → Providers
```

### **🏢 Branch Connectivity:**
```
London Office → MPLS01/MPLS02 → Toronto DC
```

---

## 📈 **IP ADDRESSING SCHEME**

### **🔐 HSRP Networks:**
| Segment | Network | HSRP Group | VIP |
|---------|---------|------------|-----|
| **ISP Transit** | 10.100.100.0/29 | Group 10 | 10.100.100.1 |
| **Customer Transit** | 10.100.200.0/29 | Group 20 | 10.100.200.1 |

### **🏠 LAN Networks:**
| Location | Network | Description |
|----------|---------|-------------|
| **Toronto LAN** | 10.100.1.0/24 | User workstations |
| **Toronto Servers** | 10.100.2.0/24 | Data center servers |
| **London Branch** | 10.40.0.0/24 | London office LAN |

### **🌐 NAT Ranges:**
| Range | Subnet | Usage |
|-------|--------|-------|
| **Primary** | 23.249.100.0/22 | Customer NAT pool |
| **Specific 1** | 23.249.100.0/23 | Application NAT |
| **Specific 2** | 23.249.102.0/23 | Service NAT |

### **🔧 Management:**
| Network | Usage |
|---------|-------|
| **192.168.16.0/24** | Device management |
| **192.168.1.0/24** | External simulation |

---

## 🚀 **REDUNDANCY & FAILOVER**

### **🔄 HSRP Configuration:**
- **Group 10 (ISP-side):** INT01 Active, INT02 Standby
- **Group 20 (Customer-side):** INT01 Active, INT02 Standby
- **Preemption:** Enabled for automatic failover

### **🌐 BGP Routing:**
- **iBGP:** INT01 ↔ INT02 (AS 62881)
- **eBGP:** INT01/INT02 ↔ Cloudflare_PE01 (via GRE tunnels)
- **Provider BGP:** Cloudflare ↔ Zayo, Bell, Google

### **🔗 GRE Tunnels (Backup Path):**
| Tunnel | Source | Destination | Network |
|--------|--------|-------------|---------|
| **Tunnel1** | INT01 | Cloudflare Lo1 | 172.16.1.0/30 |
| **Tunnel2** | INT01 | Cloudflare Lo2 | 172.16.2.0/30 |
| **Tunnel3** | INT02 | Cloudflare Lo1 | 172.16.3.0/30 |
| **Tunnel4** | INT02 | Cloudflare Lo2 | 172.16.4.0/30 |

---

## 🔒 **SECURITY ARCHITECTURE**

### **🛡️ PaloAlto Zones:**
- **Internet Zone:** External connectivity (eth1/1)
- **Internal Zone:** Customer LAN access (eth1/2)  
- **DMZ Zone:** Server farm access (eth1/3)

### **🔄 NAT Policies:**
- **Source NAT:** 10.100.x.x → 23.249.x.x
- **Destination NAT:** 23.249.x.x → 10.100.x.x
- **Policy:** Allow Internal → Internet, Deny Internet → Internal

---

## 📊 **TRAFFIC FLOWS**

### **⬆️ Outbound (Customer → Internet):**
1. **Customer** (10.100.x.x) → **PaloAlto** (NAT to 23.249.x.x)
2. **PaloAlto** → **Customer HSRP VIP** (10.100.200.1)
3. **INT01/INT02** → **ISP HSRP VIP** (10.100.100.1)
4. **ISP_Router** → **Internet**

### **⬇️ Inbound (Internet → Customer):**
1. **Internet** → **ISP_Router** (23.249.x.x traffic)
2. **ISP_Router** → **Customer HSRP VIP** (10.100.100.1)
3. **INT01/INT02** → **PaloAlto** (10.100.200.4)
4. **PaloAlto** (NAT) → **Customer** (10.100.x.x)

### **🔄 Backup Path (via Cloudflare):**
1. **INT01/INT02** → **GRE Tunnels** → **Cloudflare_PE01**
2. **Cloudflare_PE01** → **Zayo/Bell/Google** → **Internet**

---

## 🎯 **KEY FEATURES**

### ✅ **High Availability:**
- Dual HSRP groups for ISP and customer separation
- iBGP between core routers for route redundancy
- Multiple Internet paths (ISP direct + Cloudflare CDN)

### ✅ **Scalability:**
- VLAN-based architecture for easy expansion
- Route summarization for optimal routing tables
- Modular design for adding new sites

### ✅ **Security:**
- Zone-based firewall with NAT
- Private IP addressing on customer transit
- Proper network segmentation

### ✅ **Multi-Provider:**
- Cloudflare for CDN and DDoS protection
- Zayo, Bell, Google for provider diversity
- MPLS for secure branch connectivity

**This is a production-ready enterprise network with full redundancy, security, and scalability!** 🚀