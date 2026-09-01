#!/bin/bash

num=$1

if [ $num -gt 20 ]; then
   echo "given num is :: $num is greater than 20"
elif [ $num -eq 20 ]; then
    echo "given num is:: $num is equal than 20"
else
    echo "given num is :: $num is less than 20"
fi