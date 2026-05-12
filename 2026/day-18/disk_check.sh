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
