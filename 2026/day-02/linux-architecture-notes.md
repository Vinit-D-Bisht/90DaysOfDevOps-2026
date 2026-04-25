
1) Kernel
- It controls hardware, memory, and CPU
- it do system calls for applications

2) User Space
- here we can run apps/utilities in shell
- we take help from kernel for all resource access

3) systemd
- First process started (PID 1)
- Boots the system and manages services

4) Process Creation & Management
- All processes are created using fork() and executed with exec()
- Each process has a PID (process ID)
- Kernel allocates CPU time

5) Process states:
- Running (R): Currently running and actively using CPU
- Sleeping (S): waiting for input/output
- Terminated (T): killed process

6) What systemd Does

- It starts programs automatically when the system boots.
- Handles service dependencies and boot processes
- Enables service recovery 

7)  5 Daily Commands

- ps — view running all processes
- pwd - prints the current directory
- cd - change directory or position
- clear - clears the terminal
- mkdir - makes new directory in the current position

