## Task 1: Basic Functions
### functions.sh
```bash
#!/bin/bash

greet() {
	local name="$1"
	echo "hello, $name"
}
add() {
	local n1="$1"
	local n2="$2"
	echo "addition of 2 numbers are: $((n1+n2))"
}

read -p "Enter name: " n
read -p "Enter first number to add: " a
read -p "Enter second number to add: " b

greet "$n"

add "$a" "$b"
```
### Output
```bash
Enter name: Vinit
Enter first number to add: 10
Enter second number to add: 20

hello, Vinit
addition of 2 numbers are: 30
```


# Task 2: Functions with Return Values
### disk_check.sh
```bash
#!/bin/bash

check_disk() {
	echo "Disk usage of / "
	df -h | grep -w /
}
check_mem(){
	echo "Memory check"
	free -h
}

check_disk
check_mem
```
### Output
```bash
Disk usage of /
/dev/sda2        25G   12G   12G  50% /

Memory check
               total        used        free      shared  buff/cache   available
Mem:           1.9Gi       1.0Gi       103Mi        11Mi       770Mi       731Mi
Swap:          2.6Gi       450Mi       2.2Gi
```

# Task 3: Strict Mode — set -euo pipefail
### strict_demo.sh
```bash
#!/bin/bash

set -euo pipefail

set -u
echo "$Var"
echo "WHy this man"

set -e
cd akjdfdg

set -o pipefail
ls | grep .
```
### Output
```bash
./strict_demo.sh: line 6: Var: unbound variable
```
### Explanation
- `set -e` → exits script immediately if a command fails
- `set -u` → exits script when using undefined variables
- `set -o pipefail` → fails pipeline if any command inside pipeline fails


# Task 4: Local Variables
### local_demo.sh
```bash
#!/bin/bash

g="RV"
localfunc() {
	local a="$1"
	echo "This function uses local variable $a"
}
RegularvarFunc() {
	echo "This is a regular variable $g"
}

localfunc "XYZ"

RegularvarFunc
```
### Output
```bash
This function uses local variable XYZ
This is a regular variable RV
```

### Observation
- Local variables work only inside functions
- Regular variables can be accessed globally


# Task 5: System Info Reporter
### system_info.sh
```bash
#!/bin/bash

set -euo pipefail
hostname_and_OS_info() {
	echo -e "\nHostname is "
	hostname
	echo -e "\nOS info is "
	uname -a
}
uptimech() {
	echo -e "\nUptime is "
	uptime
}
disk_usage() {
	echo -e "\nDisk usage "
	du -sh * | sort -r | head -n 5
}
memory_usage() {
	echo -e "\nMemory Info "
	free -w 
}
CPU_consuming_processes() {
	echo -e "\nCPU consuming processes(top 5) "
	ps -eo pid,comm,%cpu,%mem --sort=-%cpu | head -n 5
}
main() {
	hostname_and_OS_info
	uptimech
	disk_usage
	memory_usage
	CPU_consuming_processes
}

main
```
### Output
```bash
Hostname is
ubuntu

OS info is
Linux ubuntu 6.8.0-111-generic #111~22.04.1-Ubuntu SMP PREEMPT_DYNAMIC Tue Apr 14 17:13:45 UTC x86_64 x86_64 x86_64 GNU/Linux

Uptime is
12:51:30 up 46 min, 1 user, load average: 0.26, 0.12, 0.15

Disk usage
4.0K	system_info.sh
4.0K	strict_demo.sh
4.0K	README.md
4.0K	local_demo.sh
4.0K	functions.sh

Memory Info
               total        used        free      shared     buffers       cache   available
Mem:         2015720     1087544      105660       11024       33552      788964      749444
Swap:        2744316      461004     2283312

CPU consuming processes(top 5)
    PID COMMAND         %CPU %MEM
   2291 gnome-shell      6.4 11.3
    672 java             0.9 12.2
   3047 x-terminal-emul  0.5  4.0
   1915 packagekitd      0.4  2.9
```


# What I Learned

- Functions make shell scripts cleaner, reusable, and easier to manage.
- `set -euo pipefail` helps write safer scripts by handling errors properly.
- Local variables prevent unwanted changes outside functions and improve script reliability.
