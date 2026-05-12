#!/bin/bash

g="RV"

localfunc() {
	local a="$1"
	echo "This function uses local variable $a"
}

RegularvarFunc() {
	echo "This is a regular variable $g"
}


#local b="ABC"


localfunc "XYZ"

RegularvarFunc
