## File Creation & Writing

### 1. Create file
touch notes.txt

### 2. Write first line (overwrite)
echo 'day-06 of 90 days of devops' > notes.txt

### 3. Append second line
echo 'this file is temporary ' >> notes.txt

### 4. Append third line using tee
echo 'keep practicing and honing your skills' | tee -a notes.txt
**Output:**
keep practicing and honing your skills

## File Content

### Read full file
cat notes.txt
**Output:**
day-06 of 90 days of devops
this file is temporary 
keep practicing and honing your skills 

### Read first 2 lines
head -n 2 notes.txt
**Output:**
day-06 of 90 days of devops
this file is temporary 

### Read last 2 lines
tail -n 2 notes.txt
**Output:**
this file is temporary 
keep practicing and honing your skills 

## Key Learnings

- `>` overwrites existing file content  
- `>>` appends new content  
- `tee` writes to file and displays output at same time  
- `cat` reads full file  
- `head` and `tail` help read specific parts from top or bottom
