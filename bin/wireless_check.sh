#! /bin/bash
count=$(ping -c 3 www.google.com | grep 'received' | awk -F ',' '{print $2}' | awk '{print $1}')
if [ $count == 3  ]; then
	echo "up"
else
	echo "down"
fi
