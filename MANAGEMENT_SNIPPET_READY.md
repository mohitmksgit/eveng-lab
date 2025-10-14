# 🔧 **CISCO MANAGEMENT SNIPPET - COPY/PASTE READY**

## 📋 **Complete Management Configuration Block**

### **🎯 Universal Snippet (Works for ALL Cisco Devices):**

```cisco
!
! === MANAGEMENT AND SECURITY CONFIGURATION ===
!
! Enable password and user accounts
enable secret admin123
username admin privilege 15 secret admin123
!
! Management interface (ethernet0/0)
interface ethernet0/0
 description Management Interface
 ip address {{ mgmt_ips[inventory_hostname] }} 255.255.255.0
 no shutdown
!
! Domain and SSH configuration
ip domain-name lab.local
crypto key generate rsa modulus 1024
ip ssh version 2
ip ssh time-out 60
ip ssh authentication-retries 3
!
! Management access control
access-list 1 permit 192.168.16.0 0.0.0.255
access-list 1 deny any log
!
! VTY line configuration (SSH access)
line vty 0 15
 login local
 transport input ssh
 access-class 1 in
 exec-timeout 30 0
 logging synchronous
!
! Console line configuration
line console 0
 login local
 exec-timeout 30 0
 logging synchronous
!
! === END MANAGEMENT CONFIGURATION ===
!
```

---

## 🎯 **Device-Specific IP Addresses**

### **For Templates (Use Variables):**
```cisco
interface ethernet0/0
 description Management Interface
 ip address {{ mgmt_ips[inventory_hostname] }} 255.255.255.0
 no shutdown
```

### **For Manual Configuration (Static IPs):**

| Device | Management IP | Interface Configuration |
|--------|---------------|------------------------|
| **ISP_ROUTER** | 192.168.16.101 | `ip address 192.168.16.101 255.255.255.0` |
| **INT01** | 192.168.16.102 | `ip address 192.168.16.102 255.255.255.0` |
| **INT02** | 192.168.16.103 | `ip address 192.168.16.103 255.255.255.0` |
| **Cloudflare_PE01** | 192.168.16.104 | `ip address 192.168.16.104 255.255.255.0` |
| **Zayo_Router_01** | 192.168.16.105 | `ip address 192.168.16.105 255.255.255.0` |
| **Bell_Router_01** | 192.168.16.106 | `ip address 192.168.16.106 255.255.255.0` |
| **Google_PE01** | 192.168.16.107 | `ip address 192.168.16.107 255.255.255.0` |
| **Server_Test** | 192.168.16.108 | `ip address 192.168.16.108 255.255.255.0` |
| **MPLS01** | 192.168.16.109 | `ip address 192.168.16.109 255.255.255.0` |
| **MPLS02** | 192.168.16.110 | `ip address 192.168.16.110 255.255.255.0` |
| **London_Router_01** | 192.168.16.111 | `ip address 192.168.16.111 255.255.255.0` |
| **L2_DC_SW01** | 192.168.16.120 | `ip address 192.168.16.120 255.255.255.0` |
| **L2_DC_SW02** | 192.168.16.121 | `ip address 192.168.16.121 255.255.255.0` |

---

## 🛠️ **Quick Implementation Guide**

### **Step 1: Add User/Password (Top of Config):**
```cisco
! Add right after hostname
enable secret admin123
username admin privilege 15 secret admin123
```

### **Step 2: Configure Management Interface:**
```cisco
! Replace existing ethernet0/0 configuration
interface ethernet0/0
 description Management Interface
 ip address 192.168.16.XXX 255.255.255.0  ! Use device-specific IP
 no shutdown
```

### **Step 3: Configure SSH Security:**
```cisco
! Add before line configurations
ip domain-name lab.local
crypto key generate rsa modulus 1024
ip ssh version 2
ip ssh time-out 60
ip ssh authentication-retries 3
```

### **Step 4: Configure Access Control:**
```cisco
! Replace existing line configurations
access-list 1 permit 192.168.16.0 0.0.0.255
access-list 1 deny any log

line vty 0 15
 login local
 transport input ssh
 access-class 1 in
 exec-timeout 30 0
 logging synchronous

line console 0
 login local
 exec-timeout 30 0
 logging synchronous
```

---

## ✅ **Verification Commands**

### **After Applying Configuration:**
```cisco
! Check management interface status
show ip interface brief | include ethernet0/0

! Verify SSH configuration
show ip ssh

! Check user accounts
show running-config | section username

! Test connectivity
ping 192.168.16.1  ! Gateway
```

### **Test SSH Access:**
```bash
# From management workstation:
ssh admin@192.168.16.101  # Test each device
# Password: admin123
```

---

## 📋 **Configuration Features**

### **✅ Security Features:**
- ✅ **Strong authentication** (username/password + enable secret)
- ✅ **SSH v2 only** (no Telnet)
- ✅ **Access control lists** (management network only)
- ✅ **Session timeouts** (30 minutes)
- ✅ **Login attempts limit** (3 retries)

### **✅ Management Features:**
- ✅ **Dedicated management interface** (ethernet0/0)
- ✅ **Consistent IP addressing** (192.168.16.0/24)
- ✅ **Logging synchronous** (clean console output)
- ✅ **Both SSH and console access**

**Ready to deploy standardized management across all Cisco devices!** 🚀