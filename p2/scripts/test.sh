#!/bin/bash

for i in 1 2 3; do
	host="Host: app$i.com"
	echo testing $host
	curl -s --header "$host" http://192.168.42.110 | grep "Hello from"
done
