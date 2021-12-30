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

# Создаём новый S3 bucket
echo "$0 sript: trying to create an S3 bucket with name \"$stack_name\""
aws s3 mb s3://"$stack_name"

# Создаём веб странички для размещения в S3 bucket
echo "$0 sript: trying to create a \"$file_1_name\" file."
echo -E "<!DOCTYPE html><html><head><META HTTP-EQUIV=\"Content-Type\"CONTENT=\"text/html;charset=UTF8\"><title>Andersen DevOps cource: task_07</title><style type= \"text/css\"></style> </head><script type= \"text/javascript\" language=\"JavaScript\"> </script><body><h1>task_07</h1>This is bucket $file_1_name.</body></html>" > ./"$file_1_name"
echo "$0 sript: trying to create a \"$file_2_name\" file."
echo -E "<!DOCTYPE html><html><head><META HTTP-EQUIV=\"Content-Type\"CONTENT=\"text/html;charset=UTF8\"><title>Andersen DevOps cource: task_07</title><style type= \"text/css\"></style> </head><script type= \"text/javascript\" language=\"JavaScript\"> </script><body><h1>task_07</h1>This is bucket $file_2_name.</body></html>" > ./"$file_2_name"

# Копируем веб странички
echo "$0 sript: trying to copy a \"$file_1_name\" file to \"$stack_name\" S3 bucket."
aws s3 cp "$file_1_name" s3://"$stack_name"/"$file_1_name"
echo "$0 sript: trying to copy a \"$file_2_name\" file to \"$stack_name\" S3 bucket."
aws s3 cp "$file_2_name" s3://"$stack_name"/"$file_2_name"

# Удаляем веб странички из рабочей дирректории
echo "$0 sript: trying to delete a \"$file_1_name\" file from the working directory"
rm ./"$file_1_name"
echo "$0 sript: trying to delete a \"$file_2_name\" file from the working directory"
rm ./"$file_2_name"

# Проводим проверку шаблона cloudformation
echo "$0 sript: validate \"$template_name\" template."
aws cloudformation validate-template --template-body file://"$template_name"

# Запускаем стек AWS cloudformation по шаблону
echo "$0 sript: trying to сreate a \"$stack_name\" stack from \"$template_name\" template."
aws cloudformation create-stack --stack-name "$stack_name" --template-body file://"$template_name" --capabilities CAPABILITY_IAM
