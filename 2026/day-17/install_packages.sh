#!/bin/bash

packages="nginx curl wget"

for P in $packages; do
	if [ dpkg -s $P &> /dev/null ];then
		echo "Installed"
	else
		echo "Installing package $P..."
		sudo apt install -y $P
		echo "Installed"
	fi
done
