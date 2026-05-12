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

CPU-consuming_processes() {
	echo -e "\nCPU consuming processes(top 5) "
	ps -eo pid,comm,%cpu,%mem --sort=-%cpu | head -n 5
}

main() {
	hostname_and_OS_info
	uptimech
	disk_usage
	memory_usage
	CPU-consuming_processes
}

main
