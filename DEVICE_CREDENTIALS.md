# 🔐 **DEVICE CREDENTIALS SUMMARY**

## 📋 **Default Login Credentials**

### **🔧 Cisco Devices (All Routers & Switches):**
```
Username: admin
Password: admin123
```

**Applies to:**
- ISP_ROUTER
- INT01 & INT02
- Cloudflare_PE01
- Zayo_Router_01
- Bell_Router_01
- Google_PE01
- Server_Test
- MPLS01 & MPLS02
- London_Router_01
- L2_DC_SW01 & L2_DC_SW02
- N9K01 & N9K02 (Nexus switches)

### **🛡️ PaloAlto Firewall:**
```
Username: admin
Password: admin
```

**Applies to:**
- PaloAlto (192.168.16.130)

---

## 🌐 **Management Access Details**

### **Management Network:** `192.168.16.0/24`

| Device | Management IP | Type | Username | Password |
|--------|---------------|------|----------|----------|
| ISP_ROUTER | 192.168.16.101 | Cisco IOS | admin | admin123 |
| INT01 | 192.168.16.102 | Cisco IOS | admin | admin123 |
| INT02 | 192.168.16.103 | Cisco IOS | admin | admin123 |
| Cloudflare_PE01 | 192.168.16.104 | Cisco IOS | admin | admin123 |
| Zayo_Router_01 | 192.168.16.105 | Cisco IOS | admin | admin123 |
| Bell_Router_01 | 192.168.16.106 | Cisco IOS | admin | admin123 |
| Google_PE01 | 192.168.16.107 | Cisco IOS | admin | admin123 |
| Server_Test | 192.168.16.108 | Cisco IOS | admin | admin123 |
| MPLS01 | 192.168.16.109 | Cisco IOS | admin | admin123 |
| MPLS02 | 192.168.16.110 | Cisco IOS | admin | admin123 |
| London_Router_01 | 192.168.16.111 | Cisco IOS | admin | admin123 |
| L2_DC_SW01 | 192.168.16.120 | Cisco IOS | admin | admin123 |
| L2_DC_SW02 | 192.168.16.121 | Cisco IOS | admin | admin123 |
| **PaloAlto** | **192.168.16.130** | **PaloAlto** | **admin** | **admin** |

---

## 🔑 **Access Methods**

### **SSH Access (Cisco Devices):**
```bash
ssh admin@192.168.16.101  # Example for ISP_ROUTER
# Password: admin123
```

### **Web GUI Access (PaloAlto):**
```bash
https://192.168.16.130
# Username: admin
# Password: admin
```

### **Console Access:**
```bash
# All devices support console access with same credentials
# Console port configuration: 9600 baud, 8 data bits, no parity, 1 stop bit
```

---

## ⚠️ **Security Notes**

### **Production Deployment:**
- **CHANGE ALL DEFAULT PASSWORDS** before production use
- **Enable AAA authentication** for enterprise environments
- **Configure TACACS+/RADIUS** for centralized authentication
- **Implement role-based access control**
- **Enable logging and monitoring**

### **Lab Environment:**
- These credentials are suitable for lab/testing environments
- Ensure management network (192.168.16.0/24) is isolated
- All devices configured with SSH version 2
- Management access restricted to management network only

---

## 🛠️ **Quick Access Commands**

### **Cisco Device Quick Login:**
```bash
# SSH to any Cisco device:
ssh admin@<management_ip>
# Password: admin123

# Example commands after login:
enable
show ip interface brief
show ip route
show ip bgp summary
```

### **PaloAlto Quick Login:**
```bash
# Web interface:
https://192.168.16.130
# admin / admin

# CLI access:
ssh admin@192.168.16.130
# Password: admin
```

---

## 📋 **Deployment Checklist**

- [ ] **Verify SSH connectivity** to all Cisco devices (admin/admin123)
- [ ] **Verify web access** to PaloAlto (admin/admin)
- [ ] **Test console access** for backup connectivity
- [ ] **Confirm management VLAN** connectivity (192.168.16.0/24)
- [ ] **Plan password changes** for production deployment

**Ready for lab deployment with standardized credentials!** 🚀