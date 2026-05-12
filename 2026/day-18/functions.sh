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
