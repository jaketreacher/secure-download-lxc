#! /bin/bash
vagrant up
echo "Waiting 10 seconds for processes to start"
sleep 10
echo "------------------"
echo "Testing open ports"
echo "------------------"
nc -zv 192.168.33.10 8112 7878 8989 9117
vagrant destroy -f