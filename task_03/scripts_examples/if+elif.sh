#!/bin/bash
echo "Enter a valid number"
read n
if [ $n -eq 101 ];
then
echo "This is first number"
elif [ $n -eq 510 ];
then
echo " This is second number "
elif [ $n -eq 999 ];
then
echo " This is third number "
else
echo "No numbers over here"
fi
