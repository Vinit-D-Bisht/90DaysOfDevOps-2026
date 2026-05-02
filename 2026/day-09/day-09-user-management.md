##  Users & Groups Created

### Users:
- tokyo  
- berlin  
- professor  
- nairobi  

### Groups:
- developers  
- admins  
- project-team  

##  Group Assignments:

- tokyo → developers, project-team  
- berlin → developers, admins  
- professor → admins  
- nairobi → project-team  

##  Directories Created

- /opt/dev-project → group: developers, permission: 775  
- /opt/team-workspace → group: project-team, permission: 775  

##  Commands Used

### Create Users
```
sudo useradd -m tokyo
sudo useradd -m berlin
sudo useradd -m professor
sudo useradd -m nairobi
```

### Set Passwords
```
sudo passwd tokyo
sudo passwd berlin
sudo passwd professor
sudo passwd nairobi
```

### Create Groups
```
sudo groupadd developers
sudo groupadd admins
sudo groupadd project-team
```

### Assign Users to Groups:
```
sudo usermod -aG developers tokyo
sudo usermod -aG admins professor
sudo usermod -aG developers berlin
sudo usermod -aG admins berlin

sudo usermod -aG project-team nairobi
sudo usermod -aG project-team tokyo
```

### Verify Group Members:
```
groups tokyo
groups berlin
groups professor
groups nairobi
```

### Creating Shared Directory (Developers)
```
sudo mkdir -p /opt/dev-project
sudo chgrp developers /opt/dev-project
sudo chmod 775 /opt/dev-project
```

### Creating Team Workspace
```
sudo mkdir -p /opt/team-workspace
sudo chgrp project-team /opt/team-workspace
sudo chmod 775 /opt/team-workspace
```

### Check Workspace Access
```
sudo -u tokyo touch /opt/dev-project/test1.txt
sudo -u berlin touch /opt/dev-project/test2.txt
sudo -u nairobi touch /opt/team-workspace/testing.txt

ls -l /opt/dev-project
ls -l /opt/team-workspace
```

##  What I Learned

- How to create and manage users and groups in Linux  
- How to assign multiple groups to a user using `usermod -aG` 
- How Linux permissions (`chmod`, `chgrp`) control access to shared directories  
- Importance of group-based access in multiple user systems 
