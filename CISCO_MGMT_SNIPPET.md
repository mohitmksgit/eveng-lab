# 🔧 **CISCO DEVICE MANAGEMENT CONFIGURATION SNIPPET**

## 📋 **Standard Management Configuration for All Cisco Devices**

### **Complete Snippet (Copy/Paste Ready):**

```cisco
!
! === MANAGEMENT AND SECURITY CONFIGURATION ===
!
! Enable password and user accounts
enable secret admin123
username admin privilege 15 secret admin123
!
! Management interface configuration
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

## 🎯 **Device-Specific Variables**

### **Management IP Assignments:**

```yaml
# From network_vars.yml - mgmt_ips section:
mgmt_ips:
  ISP_ROUTER: 192.168.16.101
  INT01: 192.168.16.102
  INT02: 192.168.16.103
  Cloudflare_PE01: 192.168.16.104
  Zayo_Router_01: 192.168.16.105
  Bell_Router_01: 192.168.16.106
  Google_PE01: 192.168.16.107
  Server_Test: 192.168.16.108
  MPLS01: 192.168.16.109
  MPLS02: 192.168.16.110
  London_Router_01: 192.168.16.111
  L2_DC_SW01: 192.168.16.120
  L2_DC_SW02: 192.168.16.121
```

---

## 📝 **Individual Device Snippets**

### **ISP_ROUTER:**
```cisco
interface ethernet0/0
 description Management Interface
 ip address 192.168.16.101 255.255.255.0
 no shutdown
```

### **INT01:**
```cisco
interface ethernet0/0
 description Management Interface
 ip address 192.168.16.102 255.255.255.0
 no shutdown
```

### **INT02:**
```cisco
interface ethernet0/0
 description Management Interface
 ip address 192.168.16.103 255.255.255.0
 no shutdown
```

### **Cloudflare_PE01:**
```cisco
interface ethernet0/0
 description Management Interface
 ip address 192.168.16.104 255.255.255.0
 no shutdown
```

### **Zayo_Router_01:**
```cisco
interface ethernet0/0
 description Management Interface
 ip address 192.168.16.105 255.255.255.0
 no shutdown
```

### **Bell_Router_01:**
```cisco
interface ethernet0/0
 description Management Interface
 ip address 192.168.16.106 255.255.255.0
 no shutdown
```

### **Google_PE01:**
```cisco
interface ethernet0/0
 description Management Interface
 ip address 192.168.16.107 255.255.255.0
 no shutdown
```

### **Server_Test:**
```cisco
interface ethernet0/0
 description Management Interface
 ip address 192.168.16.108 255.255.255.0
 no shutdown
```

### **MPLS01:**
```cisco
interface ethernet0/0
 description Management Interface
 ip address 192.168.16.109 255.255.255.0
 no shutdown
```

### **MPLS02:**
```cisco
interface ethernet0/0
 description Management Interface
 ip address 192.168.16.110 255.255.255.0
 no shutdown
```

### **London_Router_01:**
```cisco
interface ethernet0/0
 description Management Interface
 ip address 192.168.16.111 255.255.255.0
 no shutdown
```

### **L2_DC_SW01:**
```cisco
interface ethernet0/0
 description Management Interface
 ip address 192.168.16.120 255.255.255.0
 no shutdown
```

### **L2_DC_SW02:**
```cisco
interface ethernet0/0
 description Management Interface
 ip address 192.168.16.121 255.255.255.0
 no shutdown
```

---

## 🔐 **Security Configuration Details**

### **User Account Configuration:**
```cisco
! Administrative user with full privileges
enable secret admin123
username admin privilege 15 secret admin123
```

### **SSH Security:**
```cisco
! Domain name required for SSH keys
ip domain-name lab.local

! Generate RSA keys for SSH
crypto key generate rsa modulus 1024

! SSH version 2 only (more secure)
ip ssh version 2
ip ssh time-out 60
ip ssh authentication-retries 3
```

### **Access Control:**
```cisco
! Allow management network only
access-list 1 permit 192.168.16.0 0.0.0.255
access-list 1 deny any log

! Apply to VTY lines
line vty 0 15
 access-class 1 in
```

---

## 🛠️ **Template Integration**

### **How to Add to Existing Templates:**

1. **Add after hostname:**
```cisco
!
hostname DEVICE_NAME
!
! === INSERT MANAGEMENT SNIPPET HERE ===
!
ip cef
! ... rest of configuration
```

2. **Replace existing management interface:**
Look for existing `interface ethernet0/0` and replace with snippet

3. **Replace existing line configuration:**
Look for existing `line vty` and `line console` sections and replace

---

## ✅ **Verification Commands**

### **After Configuration:**
```cisco
! Check management interface
show ip interface brief | include ethernet0/0

! Check SSH status
show ip ssh

! Check user accounts
show running-config | section username

! Test SSH access
ssh admin@192.168.16.101
```

---

## 📋 **Quick Deployment Checklist**

- [ ] **Copy snippet** to each Cisco device template
- [ ] **Update IP address** for each device (or use variable)
- [ ] **Verify SSH connectivity** after deployment
- [ ] **Test console access** as backup
- [ ] **Confirm access-list** permits management network

**Ready to standardize management access across all Cisco devices!** 🚀