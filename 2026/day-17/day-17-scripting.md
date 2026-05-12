## Task 1: For Loop
### for_loop.sh
```bash
#!/bin/bash

Fruits=("Apple" "mango" "watermelon" "banana" "grapes")
for item in $Fruits; do
	echo "$item"
done
```
### Commands Used
```bash
chmod +x for_loop.sh
./for_loop.sh
```
### Output
```bash
Apple
mango
watermelon
banana
grapes
```

## count.sh
```bash
#!/bin/bash

for num in {1..10}; do
	echo "$num"
done
```
### Commands Used
```bash
chmod +x count.sh
./count.sh
```
### Output
```bash
1
2
3
4
5
6
7
8
9
10
```


# Task 2: While Loop
## countdown.sh
```bash
#!/bin/bash

read -p "Enter number to start countdown: " num
while [ $num -ge 0 ]; do
	echo "$num"
	((num--))
done
echo "Done"
```
### Commands Used
```bash
chmod +x countdown.sh
./countdown.sh
```
### Output
```bash
Enter number to start countdown: 3
3
2
1
0
Done
```

# Task 3: Command-Line Arguments
## greet.sh
```bash
#!/bin/bash

if [ -z "$1" ]; then
	echo "Usage: ./greet.sh <name>"
else
	echo "Hello, $1"
fi
```
### Commands Used
```bash
chmod +x greet.sh
./greet.sh
./greet.sh Vinit
```
### Output
```bash
Usage: ./greet.sh <name>
```
```bash
Hello, Vinit
```


## args_demo.sh
```bash
#!/bin/bash

echo "Total number of Arguments: $#"
echo "All arguments: $@"
echo "Script name: $0"
```
### Commands Used
```bash
chmod +x args_demo.sh
./args_demo.sh hello devops linux
```
### Output
```bash
Total number of Arguments: 3
All arguments: hello devops linux
Script name: ./args_demo.sh
```


# Task 4: Install Packages via Script
## install_packages.sh
```bash
#!/bin/bash

if [ "$EUID" -ne 0 ]; then
	echo "Please run as root"
	exit 1
fi

packages="nginx curl wget"

for P in $packages; do
	if dpkg -s $P &> /dev/null; then
		echo "$P is already installed"
	else
		echo "Installing package $P..."
		apt install -y $P
		echo "$P Installed"
	fi
done
```
### Commands Used
```bash
chmod +x install_packages.sh
sudo ./install_packages.sh
```
### Output
```bash
nginx is already installed
curl is already installed
wget is already installed
```


# Task 5: Error Handling
## safe_script.sh
```bash
#!/bin/bash

set -e

mkdir /tmp/devops-test || echo "Directory already exists"

cd /tmp/devops-test || echo "Failed to enter directory" || exit 1
	

touch test-file.txt || echo "Failed to create file"

echo "Done"
```
### Commands Used
```bash
chmod +x safe_script.sh
./safe_script.sh
```
### Output
```bash
Done
```

# What I Learned
- Bash for and while loops help automate repetitive tasks efficiently.
- Command-line arguments ($1, $#, $@) make scripts flexible and reusable.
- Error handling, root checks, and automated package installation improve script reliability and execution.
