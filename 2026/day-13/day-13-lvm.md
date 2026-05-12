##  Commands Used

### Switch to root
```
sudo -i
```

### Create virtual disk (no spare disk case)
```
dd if=/dev/zero of=/tmp/disk1.img bs=1M count=1024
losetup -fP /tmp/disk1.img
losetup -a
```

### Check current storage
```
lsblk
pvs
vgs
lvs
df -h
```

### Create Physical Volume
```
pvcreate /dev/loop0
pvs
```

### Create Volume Group
```
vgcreate devops-vg /dev/loop0
vgs
```

### Create Logical Volume
```
lvcreate -L 500M -n app-data devops-vg
lvs
```

### Format and Mount
```
mkfs.ext4 /dev/devops-vg/app-data
mkdir -p /mnt/app-data
mount /dev/devops-vg/app-data /mnt/app-data
df -h /mnt/app-data
```

### Extend Logical Volume
```
lvextend -L +200M /dev/devops-vg/app-data
resize2fs /dev/devops-vg/app-data
df -h /mnt/app-data
```

##  What I Learned

- LVM allows flexible disk management   
- Logical volumes can be extended easily compared to traditional partitions  
- Proper sequence is important: PV -> VG -> LV -> filesystem -> mount  

