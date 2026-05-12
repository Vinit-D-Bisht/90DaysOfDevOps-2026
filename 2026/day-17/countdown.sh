#!/bin/bash

read -p "Enter number to start countdown: " num

while [ $num -ge 0 ]; do
	echo "$num"
	((num--))
done
echo "Done"
