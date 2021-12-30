#!/bin/bash

# Устанавливаем значения обязательных для работы скрипта переменных
stack_name="task-07"
template_name="task-07.yaml"

if [ "$#" -eq 1 ];
 then
  stack_name=$1
elif [ "$#" -eq 2 ];
 then
  stack_name=$1
  template_name=$2
fi

# Получаем описание стека cloudformation
echo "$0 sript: getting a description of the stack \"$stack_name\"."
aws cloudformation get-template --stack-name "$stack_name"

# Обновляем стек AWS cloudformation
echo "$0 sript: trying to update a \"$stack_name\" stack from \"$template_name\" template."
aws cloudformation deploy --stack-name "$stack_name" --template "$template_name" --capabilities CAPABILITY_IAM
