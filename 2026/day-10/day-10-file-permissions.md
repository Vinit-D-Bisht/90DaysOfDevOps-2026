##  Files and Directory Created

- devops.txt  
- notes.txt  
- script.sh  
- project/ 

##  Commands Used

### Create files
```
touch devops.txt
echo "This is made using echo" > notes.txt
vim script.sh
```
Content inside script.sh:
```
echo "Hello DevOps"
```


### Verify files
```
ls -l
```

### Read files
```
cat notes.txt
vim -R script.sh
head -n 5 /etc/passwd
tail -n 5 /etc/passwd
```

##  Permission Changes

### Default permissions
```
ls -l devops.txt notes.txt script.sh
```
```
-rw-r--r-- devops.txt
-rw-r--r-- notes.txt
-rw-r--r-- script.sh
```

### 1. Make script executable
```
chmod +x script.sh
./script.sh
```
```
ls -l
```
```
-rwxr-xr-x script.sh
```

### 2. Make devops.txt read-only
```
chmod -w devops.txt
```
```
ls -l
```
```
-r--r--r-- devops.txt
```


### 3. Set notes.txt to 640
```
chmod 640 notes.txt
```
```
ls -l
```
```
-rw-r----- notes.txt
```


### 4. Create directory with 755
```
mkdir project
chmod 755 project
```
```
ls -l
```
```
drwxr-xr-x project
```


##  Permission Understanding

Format: `rwxrwxrwx`

- Owner → first 3 (rwx)  
- Group → next 3 (rwx)  
- Others → last 3 (rwx)  

For Example:
```
-rwxr-xr-x script.sh
```

- Owner: read, write, execute  
- Group: read, execute  
- Others: read, execute  


##  Test Permissions

### Write to read-only file
```
echo "test" >> devops.txt
```
Output:
```
Permission denied: devops.txt
```


### Execute without permission 
```
./script.sh
```
Output:
```
Permission denied: ./script.sh
```

##  What I Learned

- How to create and read files using Linux commands  
- How to understand and modify file permissions using chmod  
- Importance of execute permission for scripts  
- How Linux manages access control using rwx   

