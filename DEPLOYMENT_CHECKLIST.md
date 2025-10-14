# 🚀 **ANSIBLE DEPLOYMENT CHECKLIST**

## ✅ **Pre-Deployment Verification:**

### **1. Ansible Collections Installed:**
```bash
ansible-galaxy collection install cisco.ios
ansible-galaxy collection install cisco.nxos  
ansible-galaxy collection install paloaltonetworks.panos
```

### **2. Device Connectivity:**
```bash
# Test SSH access to all devices
ansible all -m ping -i inventory.yml
```

### **3. Credential Configuration:**
- Update `inventory.yml` with correct SSH passwords
- Verify management IP addresses (192.168.16.101-130)
- Test PaloAlto API access

## 🎯 **Deployment Order:**

### **Phase 1: Core Infrastructure**
```bash
# 1. ISP Router (Foundation)
ansible-playbook -i inventory.yml deploy.yml --limit isp_router

# 2. Internet Routers (Core)  
ansible-playbook -i inventory.yml deploy.yml --limit int01,int02

# 3. Provider Edge Routers
ansible-playbook -i inventory.yml deploy.yml --limit google_pe,bell_pe,zayo_pe
```

### **Phase 2: Customer & Security**
```bash
# 4. Cloudflare CE Router
ansible-playbook -i inventory.yml deploy.yml --limit cf_ce_01

# 5. PaloAlto Firewall (Last)
ansible-playbook -i inventory.yml panos_config.yml
```

### **Phase 3: Switches**
```bash
# 6. Core & Access Switches
ansible-playbook -i inventory.yml deploy.yml --limit core_switches,access_switches
```

## 🔍 **Post-Deployment Validation:**

### **1. HSRP Status Check:**
```bash
# Check ISP-side HSRP (Group 10)
show standby group 10

# Check Customer-side HSRP (Group 20)  
show standby group 20
```

### **2. BGP Session Verification:**
```bash
# INT01/INT02 - Check iBGP
show ip bgp summary

# CF_CE_01 - Check eBGP via tunnels
show ip bgp summary
show ip bgp neighbors 172.16.x.x
```

### **3. GRE Tunnel Status:**
```bash
# INT01/INT02 - Verify 4 tunnels UP
show interface tunnel 1
show interface tunnel 2
show interface tunnel 3
show interface tunnel 4

# CF_CE_01 - Verify tunnel endpoints
show interface tunnel 10
show interface tunnel 20
show interface tunnel 30
show interface tunnel 40
```

### **4. Routing Table Verification:**
```bash
# ISP_Router - Customer routes via HSRP VIP
show ip route 23.249.100.0

# INT01/INT02 - Default via ISP HSRP VIP
show ip route 0.0.0.0

# PaloAlto - Default via Customer HSRP VIP
show routing route destination 0.0.0.0/0
```

### **5. PaloAlto Security Validation:**
```bash
# Zone configuration
show zone all

# NAT policies
show running nat-policy

# Security policies
show running security-policy
```

## 📊 **Network Summary:**

### **AS Numbers:**
- **AS 15830:** ISP_Router
- **AS 62881:** INT01, INT02  
- **AS 13335:** CF_CE_01
- **AS 15169:** Google_PE
- **AS 855:** Bell_PE
- **AS 6461:** Zayo_PE

### **HSRP Groups:**
- **Group 10:** ISP-Customer Transit (10.100.100.0/29)
- **Group 20:** Customer-Internal Transit (10.100.200.0/29)

### **Key VIPs:**
- **10.100.100.1:** ISP-side HSRP VIP (ISP_Router gateway)
- **10.100.200.1:** Customer-side HSRP VIP (PaloAlto gateway)

### **GRE Tunnels:**
| Tunnel | Source | Destination | Network |
|--------|--------|-------------|---------|
| Tunnel1 | INT01 | CF_CE_01 Lo1 | 172.16.1.0/30 |
| Tunnel2 | INT01 | CF_CE_01 Lo2 | 172.16.2.0/30 |
| Tunnel3 | INT02 | CF_CE_01 Lo3 | 172.16.3.0/30 |
| Tunnel4 | INT02 | CF_CE_01 Lo4 | 172.16.4.0/30 |

## ⚠️ **Critical Success Factors:**

1. **✅ HSRP Groups Separated:** No conflicts between ISP/Customer
2. **✅ Private IP Transit:** No public IPs in customer infrastructure  
3. **✅ Redundant Paths:** HSRP + iBGP + Multiple tunnels
4. **✅ Security Zones:** PaloAlto properly segmented
5. **✅ Provider Diversity:** Zayo, Bell, Google connectivity

## 🎯 **Expected Outcomes:**

- **Primary Path:** Customer → PaloAlto → INT01/INT02 → ISP_Router → Internet
- **Backup Path:** Customer → PaloAlto → INT01/INT02 → GRE Tunnels → CF_CE_01 → Providers
- **Full Redundancy:** HSRP active/standby at both ISP and customer sides
- **Traffic Engineering:** BGP path selection via AS-path and local preference

**Configuration is production-ready for deployment!** 🚀