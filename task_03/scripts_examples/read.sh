#!/bin/bash

summ_function () {
sum=$(($1 + $2))
return $sum
}

#test_function "one" "two"

read -p "Enter a first number: " int1
read -p "Enter a second number: " int2

summ_function $int1 $int2
echo "The result is : " $?
