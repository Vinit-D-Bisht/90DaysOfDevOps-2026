## Task 1: First Script
### hello.sh
```bash
#!/bin/bash
echo "HELLO GUYS"
```
### Commands Used
```bash
chmod +x hello.sh
./hello.sh
```
### Output
```bash
HELLO GUYS
```
### Observation
- `#!/bin/bash` tells Linux to use the Bash interpreter.
- Without shebang, the script may not execute correctly depending on the shell.


# Task 2: Variables
### variables.sh
```bash
#!/bin/bash
NAME='Vinit Bisht'
ROLE='Devops engineer'
echo "Hello, I am $NAME and I am a $ROLE"
```
### Commands Used
```bash
chmod +x variables.sh
./variables.sh
```
### Output
```bash
Hello, I am Vinit Bisht and I am a Devops engineer
```
### Observation
- Variables are declared without spaces around `=`.
- Double quotes allow variable values to be used.
- Single quotes does not print variables values.


# Task 3: User Input with read
### greet.sh
```bash
#!/bin/bash
read -p "What is your name: " name
read -p "What is your favourite tool: " tool
echo "hello $name, your favourite tool is $tool"
```
### Commands Used
```bash
chmod +x greet.sh
./greet.sh
```
### Output
```bash
What is your name: Vinit
What is your favourite tool: K8S
hello Vinit, your favourite tool is K8S
```


# Task 4: If-Else Conditions
## check_number.sh
```bash
#!/bin/bash
read -p "Enter the number to check if +ve,-ve or zero: " num

if [ $num -gt 0 ]; then
	echo "your number $num is positive"
elif [ $num -lt 0 ]; then
	echo "Your number $num is negative"
else
	echo "Your number is Zero $num"
fi
```
### Commands Used
```bash
chmod +x check_number.sh
./check_number.sh
```
### Output
```bash
Enter the number to check if +ve,-ve or zero: 67
your number 67 is positive
```

### Errors Faced
```bash
./check_number.sh: line 5: [45: command not found
```
### Solution
- Spaces are required inside `[ ]` conditions:
```bash
if [ $num -gt 0 ];
```


## file_check.sh
```bash
#!/bin/bash
read -p "Enter file name to check if exists or not : " file
if [ -f "$file" ]; then
	echo "File is present"
else
	echo "File is not present"
fi
```
### Commands Used
```bash
chmod +x file_check.sh
./file_check.sh
```
### Output
```bash
Enter file name to check if exists or not : hello.sh
File is present
```

```bash
Enter file name to check if exists or not : mibomba
File is not present
```


# Task 5: Combine It All
## server_check.sh
```bash
#!/bin/bash
service="jenkins.service"
read -p "Do you want to check if jenkins service is running or not (y or n) : " P

if [ $P == "y" ]; then
	echo "you chose yes"
	systemctl status $service
else
	echo "you chose no, exited"
fi
```
### Commands Used
```bash
chmod +x server_check.sh
./server_check.sh
```
### Output
```bash
Do you want to check if jenkins service is running or not (y or n) : y
you chose yes

● jenkins.service - Jenkins Continuous Integration Server
     Loaded: loaded (/lib/systemd/system/jenkins.service; enabled)
     Active: active (running)```

```bash
Do you want to check if jenkins service is running or not (y or n) : n
you chose no, exited
```


# What I Learned
- Shebang (`#!/bin/bash`) defines which shell interpreter executes the script.
- Variables, `read`, and `echo` are basic building blocks of shell scripting.
- Proper spacing inside `if [ ]` conditions is important in Bash scripts.
- `chmod +x` makes scripts executable.
- Bash scripting helps automate Linux and DevOps tasks efficiently.
