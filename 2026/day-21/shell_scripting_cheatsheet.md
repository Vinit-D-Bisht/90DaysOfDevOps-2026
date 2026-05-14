# Shell Scripting Cheat Sheet
# 1. Basics

## Shebang

```bash
#!/bin/bash
```

Defines which interpreter should run the script.

---

## Run Script

```bash
chmod +x script.sh
./script.sh
```

or

```bash
bash script.sh
```

---

## Comments

```bash
# This is a comment
```

```bash
echo "Hello" # Inline comment
```

---

## Variables

```bash
NAME="Vinit"

echo $NAME
echo "$NAME"
echo '$NAME'
```

- `" "` → variable expands
- `' '` → treated as plain text

---

## Read User Input

```bash
read -p "Enter name: " name
echo "$name"
```

---

## Command-Line Arguments

```bash
$0 -> script name
$1 -> first argument
$# -> total arguments
$@ -> all arguments
$? -> exit status
```

Example:

```bash
./script.sh hello world
```

---

# 2. Operators and Conditionals

## String Comparisons

```bash
[ "$a" = "$b" ]
[ "$a" != "$b" ]
[ -z "$a" ]
[ -n "$a" ]
```

---

## Integer Comparisons

```bash
[ $a -eq $b ]
[ $a -ne $b ]
[ $a -lt $b ]
[ $a -gt $b ]
[ $a -le $b ]
[ $a -ge $b ]
```

---

## File Test Operators

```bash
-f file
-d dir
-e file
-r file
-w file
-x file
-s file
```

---

## If Else

```bash
if [ condition ]; then
    echo "True"
elif [ condition ]; then
    echo "Else If"
else
    echo "False"
fi
```

---

## Logical Operators

```bash
&&
||
!
```

Example:

```bash
mkdir test || echo "Already exists"
```

---

## Case Statement

```bash
case $var in
    start)
        echo "Starting"
        ;;
    stop)
        echo "Stopping"
        ;;
    *)
        echo "Invalid"
        ;;
esac
```

---

# 3. Loops

## For Loop

```bash
for fruit in apple mango banana
do
    echo $fruit
done
```

---

## C Style For Loop

```bash
for ((i=1;i<=5;i++))
do
    echo $i
done
```

---

## While Loop

```bash
while [ $num -gt 0 ]
do
    echo $num
    ((num--))
done
```

---

## Until Loop

```bash
until [ $num -eq 0 ]
do
    echo $num
    ((num--))
done
```

---

## Break and Continue

```bash
break
continue
```

---

## Loop Over Files

```bash
for file in *.log
do
    echo $file
done
```

---

## Loop Over Command Output

```bash
cat file.txt | while read line
do
    echo $line
done
```

---

# 4. Functions

## Define Function

```bash
greet() {
    echo "Hello"
}
```

---

## Call Function

```bash
greet
```

---

## Function Arguments

```bash
add() {
    echo $(($1 + $2))
}

add 5 10
```

---

## Return Values

```bash
return 1
```

```bash
echo "value"
```

---

## Local Variables

```bash
demo() {
    local name="Vinit"
    echo $name
}
```

---

# 5. Text Processing Commands

## grep

```bash
grep "error" file.log
grep -i "error" file.log
grep -r "error" .
grep -c "error" file.log
grep -n "error" file.log
grep -v "error" file.log
grep -E "ERROR|FAILED" file.log
```

---

## awk

```bash
awk '{print $1}' file.txt
awk -F: '{print $1}' /etc/passwd
```

```bash
awk 'BEGIN {print "Start"} {print $1} END {print "Done"}' file
```

---

## sed

```bash
sed 's/foo/bar/g' file.txt
```

```bash
sed '2d' file.txt
```

```bash
sed -i 's/foo/bar/g' file.txt
```

---

## cut

```bash
cut -d ":" -f1 /etc/passwd
```

---

## sort

```bash
sort file.txt
sort -n file.txt
sort -r file.txt
sort -u file.txt
```

---

## uniq

```bash
uniq file.txt
uniq -c file.txt
```

---

## tr

```bash
tr 'a-z' 'A-Z'
tr -d '\n'
```

---

## wc

```bash
wc -l file.txt
wc -w file.txt
wc -c file.txt
```

---

## head and tail

```bash
head -5 file.txt
tail -5 file.txt
tail -f app.log
```

---

# 6. Useful One-Liners

## Delete Files Older Than 7 Days

```bash
find /tmp -type f -mtime +7 -delete
```

---

## Count Lines in Log Files

```bash
wc -l *.log
```

---

## Replace String in Multiple Files

```bash
sed -i 's/old/new/g' *.txt
```

---

## Check Service Status

```bash
systemctl is-active nginx
```

---

## Monitor Disk Usage

```bash
df -h | grep -w /
```

---

## Tail Logs and Filter Errors

```bash
tail -f app.log | grep ERROR
```

---

# 7. Error Handling and Debugging

## Exit Codes

```bash
echo $?
exit 0
exit 1
```

---

## set -e

```bash
set -e
```

Exit script if command fails.

---

## set -u

```bash
set -u
```

Treat unset variables as errors.

---

## set -o pipefail

```bash
set -o pipefail
```

Fails if any command in pipeline fails.

---

## set -x

```bash
set -x
```

Shows command execution for debugging.

---

## trap

```bash
trap 'echo "Cleaning up"' EXIT
```

Runs command before script exits.

---

# What I Learned

- Shell scripting automates repetitive Linux and DevOps tasks.
- Commands like `grep`, `awk`, `sed`, and loops are powerful for automation.
- `set -euo pipefail` makes scripts safer and easier to debug.
