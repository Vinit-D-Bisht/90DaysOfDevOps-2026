# Task 1: DNS - How names became IP
### 1. What happens when you type google.com in a browser?
- The browser first checks DNS to convert `google.com` into an IP address.
- DNS servers return the IP address linked to the domain.
- The browser then connects to that IP using TCP/IP.

### 2. DNS Record Types
- `A` → Maps domain name to IPv4 address
- `AAAA` → Maps domain name to IPv6 address
- `CNAME` → Alias of one domain to another domain
- `MX` → Mail server records for email routing
- `NS` → Defines authoritative name servers for a domain

### 3. dig google.com
### Command
```bash
dig google.com
```
### Output
```bash
;; ANSWER SECTION:
google.com.        172     IN      A       142.251.220.46
```
### Observation
- A record = `142.251.220.46`
- TTL = `172`


# Task 2: IP Addressing

### 1. What is IPv4?
- IPv4 is a 32-bit IP addressing system.
- It is written in dotted decimal format like:
```bash
192.168.1.1
```
- It consists of 4 octets separated by dots.

### 2. Public vs Private IP
- Public IP → `8.8.8.8`
- Private IP → `192.168.1.10`

### 3. Private IP Ranges
```bash
10.0.0.0 – 10.255.255.255
172.16.0.0 – 172.31.255.255
192.168.0.0 – 192.168.255.255
```

### 4. ip addr show
### Command
```bash
ip addr show
```
### Observation
- Private IPs identified:
```bash
127.0.0.1
172.31.x.x
192.168.x.x
```


# Task 3: CIDR & Subnetting

### 1. What does /24 mean?
- `/24` means the first 24 bits are reserved for the network portion.
- The remaining 8 bits are available for hosts.

### 2. Usable Hosts
| CIDR | Usable Hosts |
|------|--------------|
| /24  | 254          |
| /16  | 65534        |
| /28  | 14           |

### 3. Why do we subnet?
- Subnetting helps divide networks into smaller manageable parts.
- It improves security, performance, and IP management.

### 4. CIDR Table
| CIDR | Subnet Mask     | Total IPs | Usable Hosts |
|------|-----------------|-----------|--------------|
| /24  | 255.255.255.0   | 256       | 254          |
| /16  | 255.255.0.0     | 65536     | 65534        |
| /28  | 255.255.255.240 | 16        | 14           |


# Task 4: Ports – The Doors to Services

### 1. What is a port and why do we need them?
- Ports are communication endpoints for services.
- They allow multiple services to run on one machine using different port numbers.

### 2. Common Ports
| Port  | Service  |
|-------|----------|
| 22    | SSH      |
| 80    | HTTP     |
| 443   | HTTPS    |
| 53    | DNS      |
| 3306  | MySQL    |
| 6379  | Redis    |
| 27017 | MongoDB  |

### 3. ss -tulpn
### Command
```bash
ss -tulpn
```
### Output
```bash
Netid        State         Recv-Q         Send-Q                 Local Address:Port                  Peer Address:Port        Process
udp          UNCONN        0              0                            0.0.0.0:57273                      0.0.0.0:*
udp          UNCONN        0              0                      127.0.0.53%lo:53                         0.0.0.0:*
udp          UNCONN        0              0                            0.0.0.0:5353                       0.0.0.0:*
udp          UNCONN        0              0                               [::]:5353                          [::]:*
udp          UNCONN        0              0                               [::]:36131                         [::]:*
tcp          LISTEN        0              4096                   127.0.0.53%lo:53                         0.0.0.0:*
tcp          LISTEN        0              128                        127.0.0.1:631                        0.0.0.0:*
tcp          LISTEN        0              128                            [::1]:631                           [::]:*
tcp          LISTEN        0              50                                 *:8080                             *:*
```
### Observation
- Port `53` is used for DNS services.
- Port `8080` is listening for a web application/service.


# Task 5: Putting It Together

### Q) curl http://myapp.com:8080
- DNS resolves `myapp.com` into its IP address.
- A TCP connection is established on port `8080`.
- The HTTP request is sent over the TCP/IP network.

### Q) App cannot reach database at 10.0.1.50:3306

First checks:
- Check if the database service is running.
- Check connectivity using `ping` or `nc`.
- Verify firewall/security group rules.
- Ensure MySQL is listening on port `3306`.


# What I Learned
- DNS converts domain names into IP addresses and helps systems communicate over networks.
- CIDR, subnetting, and IP addressing help organize and manage networks efficiently.
- Commands like `dig`, `ss -tulpn`, and `ip addr` are useful for checking connectivity, ports, and troubleshooting network issues.
