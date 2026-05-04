##  Files & Directories Created

- devops-file.txt  
- team-notes.txt  
- project-config.yaml  
- app-logs/  
- heist-project/ (with vault/ and plans/)  
- bank-heist/ (with 3 files inside)  


##  Ownership Changes

### devops-file.txt
Before:
```
-rw-rw-r-- 1 ubuntu ubuntu devops-file.txt
```

After:
```
-rw-rw-r-- 1 berlin ubuntu devops-file.txt
```

### team-notes.txt
Before:
```
-rw-rw-r-- 1 ubuntu ubuntu team-notes.txt
```

After:
```
-rw-rw-r-- 1 ubuntu heist-team team-notes.txt
```

### project-config.yaml
After:
```
-rw-rw-r-- 1 professor heist-team project-config.yaml
```

### app-logs/
```
drwxr-xr-x berlin heist-team app-logs/
```

### heist-project/ (recursive)
```
heist-project/plans/strategy.conf/vault/gold.txt
```

After:
```
professor planners (applied recursively)

-rw-rw-r-- 1 professor planners gold.txt
-rw-rw-r-- 1 professor planners strategy.conf
```

### bank-heist/

```
-rw-rw-r-- 1 tokyo   vault-team access-codes.txt
-rw-rw-r-- 1 berlin  tech-team  blueprints.pdf
-rw-rw-r-- 1 nairobi vault-team escape-plan.txt
```


##  Commands Used

### Create files
```
touch devops-file.txt
touch team-notes.txt
touch project-config.yaml
mkdir app-logs
```

### Create users
```
sudo useradd -m tokyo
sudo useradd -m berlin
sudo useradd -m professor
sudo useradd nairobi
```

### Create groups
```
sudo groupadd heist-team
sudo groupadd planners
sudo groupadd vault-team
sudo groupadd tech-team
```

### Change owner
```
sudo chown tokyo devops-file.txt
sudo chown berlin devops-file.txt
```

### Change group
```
sudo chgrp heist-team team-notes.txt
```

### Change owner + group
```
sudo chown professor:heist-team project-config.yaml
sudo chown berlin:heist-team app-logs
```

### Recursive ownership
```
sudo chown -R professor:planners heist-project
```


### Practice challenge
```
mkdir bank-heist
touch bank-heist/access-codes.txt
touch bank-heist/blueprints.pdf
touch bank-heist/escape-plan.txt

sudo chown tokyo:vault-team bank-heist/access-codes.txt
sudo chown berlin:tech-team bank-heist/blueprints.pdf
sudo chown nairobi:vault-team bank-heist/escape-plan.txt
```

##  What I Learned

- Difference between file owners and group owners  
- How to use `chown` and `chgrp` for managing ownership  
- Importance of `sudo` for ownership changes  
- How to apply recursive ownership using `-R`  
- How ownership is important for multi-user environments  

