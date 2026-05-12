##  OSI vs TCP/IP Models

### OSI Model (7 Layers)
- Layer 1 = Physical [cables, signals, hardware]  
- Layer 2 = Data Link [MAC address, switches]
- Layer 3 = Network [IP addressing and routing]
- Layer 4 = Transport [TCP/UDP communication]  
- Layer 5 = Session [manages sessions between applications]  
- Layer 6 = Presentation [encryption and formatting]  
- Layer 7 = Application [HTTP, DNS, SSH, browsers]  

### TCP/IP Model
- Link Layer -> hardware/network access  
- Internet Layer -> IP addressing and routing  
- Transport Layer -> TCP/UDP  
- Application Layer -> HTTP, HTTPS, DNS, SSH  


## Where each protocols is present

- IP -> Network/Internet layer  
- TCP/UDP -> Transport layer  
- HTTP/HTTPS -> Application layer  
- DNS -> Application layer  

#  Hands-on Networking Checks

## 1. Identity Check

### Command

```
hostname -I
```

### Result

```
127.0.1.1
```

### Observation
- Displays local machine IP address  
- Useful for checking current network identity  


## 2. Reachability Check

### Command

```
ping google.com
```

### Output

```
PING google.com (142.251.221.238) 56(84) bytes of data.
64 bytes from pnbomb-bk-in-f14.1e100.net (142.251.221.238): icmp_seq=1 ttl=255 time=43.4 ms
64 bytes from pnbomb-bk-in-f14.1e100.net (142.251.221.238): icmp_seq=2 ttl=255 time=79.6 ms
64 bytes from pnbomb-bk-in-f14.1e100.net (142.251.221.238): icmp_seq=3 ttl=255 time=59.5 ms
```

### Observation
- Internet connectivity is working  
- No packet loss observed  


## 3. Path Check

### Command

``` 
tracepath amazon.com
```

### Output

``` 
1?: [LOCALHOST]                      pmtu 1500
1:  _gateway                                              0.171ms 
1:  _gateway                                              0.182ms 
2:  no reply
```

### Observation
- Shows route packets take to destination  
- One hop timed out but destination is still reachable  


## 4. Port & Service Check

### Command

``` 
ss -tulpn
```

### Output

``` 
Netid        State         Recv-Q         Send-Q                 Local Address:Port                  Peer Address:Port        
udp          UNCONN        0              0                      127.0.0.53%lo:53                         0.0.0.0:*                                   
udp          UNCONN        0              0                            0.0.0.0:5353                       0.0.0.0:*                                   
tcp          LISTEN        0              50                                 *:8080                             *:*           
```

### Observation
- Multiple services are actively listening on ports  
- Port 8080 is open and accepting TCP connections  


## 5. DNS Resolution Check
### Command

``` 
nslookup google.com
```
### Output
``` 
Server:		127.0.0.53
Address:	127.0.0.53#53
Non-authoritative answer:
Name:	google.com
Address: 142.251.221.238
Name:	google.com
Address: 2404:6800:4009:80d::200e
```
### Observation
- DNS resolution working correctly  
- Domain successfully resolved into IP address  

## 6. HTTP Check
### Command
``` 
curl -I https://google.com
```

### Output
``` 
HTTP/2 301
location: https://www.google.com/
```

### Observation
- Website reachable successfully  
- HTTP 301 indicates redirect response  


## 7. Connections Snapshot
### Command

``` 
netstat -an | head
```
### Output
``` 
Active Internet connections (servers and established)
Proto Recv-Q Send-Q Local Address           Foreign Address         State      
tcp        0      0 127.0.0.53:53           0.0.0.0:*               LISTEN     
tcp        0      0 127.0.0.1:631           0.0.0.0:*               LISTEN     
```
### Observation
- Multiple services actively listening  
- Local DNS and printer services visible  


#  Mini Task – Port Probe

## Step 1: Identify Listening Port

Port selected:

``` 
8080
```
## Step 2: Probe Port

### Command

``` 
nc -zv localhost 8080
```
### Output

``` 
Connection to localhost (127.0.0.1) 8080 port [tcp/http-alt] succeeded!
```
### Observation
- Port 8080 reachable successfully  
- If failed, next checks would be:
  - `systemctl status <service>`
  - firewall rules
  - service logs  


#  Reflection

### Which command gives fastest signal?
- `ping` gives fastest indication of connectivity issues  
- `systemctl status` quickly checks service health
  
### What layer would you inspect?

#### If DNS fails:
- Application layer  
- DNS configuration/network settings  
#### If HTTP 500 appears:
- Application layer first  
- Then backend service logs  

### Two follow-up checks during incidents
1. Check logs using:
``` 
journalctl -u <service>
```
2. Check open ports/services:
``` 
ss -tulpn
```
#  What I Learned

- Networking troubleshooting follows layers systematically  
- DNS and connectivity checks are critical first steps  
- `ping`, `curl`, and `ss` provide fast diagnostics  
- Ports and services can be verified quickly using `nc` and `ss`
