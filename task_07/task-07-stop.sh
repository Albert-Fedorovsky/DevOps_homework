#!/bin/bash

# Устанавливаем значения обязательных для работы скрипта переменных
stack_name="task-07"
template_name="task-07.yaml"
file_1_name="index.html"
file_2_name="index2.html"

if [ "$#" -eq 1 ];
 then
  stack_name=$1
elif [ "$#" -eq 2 ];
 then
  stack_name=$1
  template_name=$2
fi

# Удаляем содержимое S3 bucket
echo "$0 sript: trying to clear an S3 bucket with name \"$stack_name\""
aws s3 rm s3://"$stack_name"/ --recursive

# Удаляем S3 bucket
echo "$0 sript: trying to delete an S3 bucket with name \"$stack_name\""
aws s3 rb s3://"$stack_name"/

# Удаляем стек AWS cloudformation
echo "$0 sript: trying to delete a \"$stack_name\"."
aws cloudformation delete-stack --stack-name "$stack_name"
