#!/bin/bash

# Устанавливаем значения обязательных для работы скрипта переменных
age_dimension="seconds" # размерность возраста снимков
age_divider="1"         # делитель возраста снимков соответствующий выбранным единицам измерения
age_minimum="0"         # минимальный возраст снимка в выбранных единицах измерения, определяет попадёт ли мнимок в отчёт
filter_set="no"         # активировать фильтрацию по произвольному значению строки
filter_parameter=""     # параметр, по которому будет вестись фильтрация
find_result="somevalue" # параметр определяет выводить текущую строку в отчёт или нет, по умолчанию непустой, чтобы выводить всё
copy_selected="no"      # режим создания копий выбранных снимков
delete_selected="no"    # режим удаления выбранных снимков
raw_data="no"           # режим вывода сырых данных

# Функция выводит справочную информацию скрипта
function show_help
{
  printf "\n"
  echo "  Script description:"
  printf "\n"
  echo "  The $0 script requires the aws cli native utility installed and configured. The user must have read / write access to the AWS EC2 service."
  printf "\n"
  echo "$0 script usage:"
  echo "$0 <Par1> <Par2> ... <ParN> <--Com1> <Com1Val> <--Com2> <Com2Val> ... <--ComNVal> <ComNVal>"
  printf "\n"
  echo "  <ParN> are the parameters that the script looks for in the snapshot description. Report lines are formed from these parameters. Parameters can be any text or a set of numbers, for example \"SnapshotId\", \"VolumeId\", \"Description\" or any others. Parameters can be set case-insensitively. You can also enter the name of the parameter partially. For example, if you enter \"id\", the script will display all parameters containing \"id\" and their values ​​in their name."
  echo "  The script also handles one special parameter \"Age\". Unlike the others, which are simply broadcast from AWS, \"Age\" is calculated by the script. \"Age\" is the age of the found snapshots at the time the script was called. For the script to work, you need to pass at least one parameter."
  echo "  Supported values: values ​​can be any text or set of numbers"
  echo "  Example: $0 id description"
  printf "\n"
  echo "  <--Com> and <ComNVal> are the commands and values of these commands, respectively. All commands are optional. The script supports the following commands and values:"
  printf "\n"
  echo "  --age-dimension - set the units of measure for the minimum age of images for incoming reports"
  echo "  Supported values: seconds | minutes | hours | days"
  echo "  Example: --age-dimension minutes"
  printf "\n"
  echo "  --age-minimum - set the value of the minimum age of snapshots included in the report in units of measurement set using --age-dimension."
  echo "  Supported values: positive integers"
  echo "  Example: --age-minimum 123456"
  printf "\n"
  echo "  --filter - setting the name or value of the attribute (tag) that the snapshot must contain to get into the report. Any images that do not contain the passed parameter are not included in the report."
  echo "  Supported values: values ​​can be any text or set of numbers"
  echo "  Example: --filter snap-01920209545fd225e"
  printf "\n"
  echo "  --snapshots-action - setting actions for snapshots included in the report. Two possible actions are available: create a copy or delete."
  echo "  Supported values: copy | delete"
  echo "  Example: --snapshots-action copy"
  printf "\n"
  echo "  --get-raw-data - activate the output of raw data with a description of all available snapshots from AWS."
  echo "  Supported values: the command is called without a value"
  echo "  Example: --get-raw-data"
  printf "\n"
  echo "  --help - displays this help."
  echo "  Supported values: the command is called without a value"
  echo "  Example: --help"
  printf "\n"
  echo "  The format of the data output by the script:"
  echo "Parameter name 1: Parameter value 1 | Parameter name 2: Parameter value 2 | Parameter name N: Parameter value N"
  printf "\n"
}

# Проверяем наличие входных параметров
if [ "$#" -gt 0 ] # если хотябы один параметр передан скрипту - проводим анализ
  then # в цикле в первую очередь выделяем команды
    for (( count=1; count<="$#"; count++ ))
    do
      if [ "${!count}" == "--age-dimension" ] # установка размерности минимального возраста снимков входящих отчёт
        then
          next_arg_number=$(echo "$count + 1" | bc)
          if [ "$#" -ge "$next_arg_number" ]
            then
              next_arg_value=""
              next_arg_value="${!next_arg_number}"
              if [ "$next_arg_value" != "" ]
                then
                  if [ "$next_arg_value" == "seconds" ]
                    then
                      age_dimension="seconds"
                      age_divider="1"
                  elif [ "$next_arg_value" == "minutes" ]
                    then
                      age_dimension="minutes"
                      age_divider="60"
                  elif [ "$next_arg_value" == "hours" ]
                    then
                      age_dimension="hours"
                      age_divider="3600"
                  elif [ "$next_arg_value" == "days" ]
                    then
                      age_dimension="days"
                      age_divider="86400"
                  else
                    echo "Wrong age-dimension value. It must be seconds | minutes | hours | days"
                    echo "Set defult value - $age_dimension"
                  fi
                  count=$next_arg_number
              else
                echo "Wrong argument following the --age-dimension!"
                exit 1
              fi
          else
            echo "There is no argument following the --age-dimension!"
            exit 1
          fi
      elif [ "${!count}" == "--age-minimum" ] # установка минимального возраста снимков входящих отчёт
        then
          next_arg_number=$(echo "$count + 1" | bc)
          if [ "$#" -ge "$next_arg_number" ]
            then
              next_arg_value=""
              next_arg_value=$(echo "${!next_arg_number}" | grep -oP '\d+' | head -n 1 | tail -n 1)
              if [ "$next_arg_value" != "" ]
                then
                  age_minimum="$next_arg_value"
                  count=$next_arg_number
              else
                echo "Wrong argument following the age_minimum!"
                exit 1
              fi
          else
            echo "There is no argument following the age_minimum!"
            exit 1
          fi
      elif [ "${!count}" == "--filter" ] # установка имени или значения атрибута (тега), который должен содержать снимок, чтобы попасть в отчёт
        then
          next_arg_number=$(echo "$count + 1" | bc)
          if [ "$#" -ge "$next_arg_number" ]
            then
              next_arg_value=""
              next_arg_value="${!next_arg_number}"
              if [ "$next_arg_value" != "" ]
                then
                  filter_set="yes"
                  filter_parameter="$next_arg_value"
                  count=$next_arg_number
              else
                echo "Wrong argument following the --filter!"
                exit 1
              fi
          else
            echo "There is no argument following the --filter!"
            exit 1
          fi
      elif [ "${!count}" == "--snapshots-action" ] # установка действий над снимками, попавшими в отчёт
        then
          next_arg_number=$(echo "$count + 1" | bc)
          if [ "$#" -ge "$next_arg_number" ]
            then
              next_arg_value=""
              next_arg_value="${!next_arg_number}"
              if [ "$next_arg_value" != "" ]
                then
                  if [ "$next_arg_value" == "copy" ]
                    then
                      copy_selected="yes"
                  elif [ "$next_arg_value" == "delete" ]
                    then
                      delete_selected="yes"
                  else
                    echo "Wrong --shaphots-action value. It must be copy | delete"
                    echo "No actions will be performed"
                  fi
                  count=$next_arg_number
              else
                echo "Wrong argument following the --shaphots-action!"
                exit 1
              fi
          else
            echo "There is no argument following the --shaphots-action!"
            exit 1
          fi
      elif [ "${!count}" == "--get-raw-data" ] # активировать вывод сырых данных от AWS
        then
          raw_data="yes"
      elif [ "${!count}" == "--help" ] # вызов справки
        then
          show_help
      else # все остальные аргументы используются как параметры форминуремого отчёта
        searching_args+="${!count} "
      fi
    done
else # если нет ни одного парамтра - останавливаем выполнение и выводим справку
  echo "$0 script error: for the script to work, you need to pass at least one parameter."
  show_help
  exit 1
fi

# Получаем список снимков и сохраняем его в переменную snapshots_description
snapshots_description=$(aws ec2 describe-snapshots --owner-ids self)

# Если активирован режим вывода сырых данных - выводим их
if [ "$raw_data" == "yes" ]
  then
    echo "$snapshots_description"
fi

# Функция формирует отчёт скрипта из списка параметров, передаваемых вызове
# скриптa, например, SnapshotId, StartTime, VolumeSize, Age и других.
# Age вычисляемый параметр, потому обрабатывается по отличному от остальных
# параметров алгоритму.
function generate_report
{
  if [ "$#" -gt 0 ]
    then
    searching_args="$1"
  fi

  # Подсчитываем количество EBS snapshot и схраняем eго в переменную
  # snapshots_number.
  # Количество EBS snapshot определяем по количеству строк, содержащих параметр
  # SnapshotId. Строки, содержащие SnapshotId выделяем при помощи grep.
  # Параметр SnapshotId используется как шаблон для grep.
  # Количество строк, выделенных grep подсчитывем при помощи wc
  # При помощи команды tr удаляем повторяющиеся пробельные символы
  # -s --squeeze-repeats	- замещать последовательность знаков, которые
  # повторяются, из перечисленных в последнем НАБОРЕ, на один такой знак
  # " " - повторяющийся символ. Далее удаляем первый пробел при помощи cut
  # (вырезаем строку начиная со 2 символа и до конца -), веделяем параметр l при
  # помощи cut, т.е. оставляем первый столбец отделённый пробельным символом.
  snapshots_number=$(echo "$snapshots_description" | grep 'SnapshotId' | wc | tr -s " " | cut -c 2- | cut -d " " -f 1)

  # Выполняем проверку на предмет повторения фрагментов имени искомого параметра с
  # соответствующим дополнением списка на основании которого будет формироваться отчёт
  searching_args_completed_list="" # подготавливаем переменную для записи параметров
  for var in $searching_args # в цикле добавляем в список все параметры
  do
    var_found_number=$(echo "$snapshots_description" | grep -i "$var" | wc | tr -s " " | cut -c 2- | cut -d " " -f 1)
    var_repeat_in_one_snapshot=$(echo "$var_found_number / $snapshots_number" | bc)
    if [ "$var_repeat_in_one_snapshot" -gt 0 ] # если параметр не встречается в описании найденных snapshots
    then
      for (( repeat_count=1; repeat_count<="$var_repeat_in_one_snapshot"; repeat_count++ ))
      do
        searching_args_completed_list+="$var "
      done
    else
      searching_args_completed_list+="$var "
    fi
  done

  # Подсчитываем количество аргументов для в полном списке
  searching_args_number=$(echo "$searching_args_completed_list" | wc | tr -s " " | cut -c 2- | cut -d " " -f 2)

  # Обнуляем переменную в которой будем накапливать результаты
  snapshots_paremeters=""

  # Получаем текущее время в секундах от начала эпохи ЭВМ
  seconds_that_moment_from_era_begin=$(date +%s -u)
  for (( count=1; count<="$snapshots_number"; count++ ))
  do
    searching_arg_current_number="1"

    # Выделяем время создания текущего снимка в формате "%FT%T"
    # (гггг-мм-ддTчч:мм:сс)
    date_and_time_current_ebs=$(echo "$snapshots_description" | grep -oP '(\d+-){2}\d+T(\d+:){2}\d+' | head -n "$count" | tail -n 1)

    # Пересчитываем время создания снимка в формат секунд от начала эпохи ЭВМ
    seconds_current_ebs_from_era_begin=$(date -d "$date_and_time_current_ebs" +%s -u)

    # Вычисляем давность создания текущего снимка в выбранных единицах времени
    age_current_ebs=$(echo "(${seconds_that_moment_from_era_begin} - ${seconds_current_ebs_from_era_begin}) / $age_divider" | bc)

    # Если активирован фильтр поиска, проводим проверку текущего снимка на
    # предмет наличия в нём искомых значений
    if [ "$filter_set" == "yes" ]
      then
        snapshot_index=$(echo "$count + 2" | bc)
        find_result=$(echo "$snapshots_description" | tr -d "\n" | cut -d "{" -f "$snapshot_index" | grep -io "$filter_parameter")
    fi

    # Исключаем попадание в отчёт строки не удовлетворяющих критериям
    # минимальной давности и фильтра поиска
    if [ "$age_current_ebs" -ge "$age_minimum" -a -n "$find_result" ]
      then
        for var in $searching_args # выводим данные по искомым параметрам
        do
          #if [ "$var" == "Age" ] # если параметр равен Age, учитывая регистр
          if [ "$var" == "Age" -o "$var" == "age" ] # если параметр равен Age или age, учитывая регистр
          # if test "${var#*Age}" != "$var" # если параметр содержит Age, учитывая регистр
          # if [ -n "$(echo "$var" | grep -i "Age")" ] # если параметр содержит Age, не учитывая регистр

            # Формируем значение давности создания снимка в выбранных единицах
            # измерения времени c фиксированным количеством разрядов, чтобы отчёт
            # печатался ровно
            then
              if [ "$age_dimension" == "days" ]
                then
                  age_current_ebs_normalize=$(printf "%06d\n" $age_current_ebs)
              elif [ "$age_dimension" == "hours" ]
                then
                  age_current_ebs_normalize=$(printf "%07d\n" $age_current_ebs)
              elif [ "$age_dimension" == "minutes" ]
                then
                  age_current_ebs_normalize=$(printf "%09d\n" $age_current_ebs)
              else
                age_current_ebs_normalize=$(printf "%010d\n" $age_current_ebs)
              fi
              snapshots_paremeters+="Age: $age_current_ebs_normalize $age_dimension"

              # Если это не последний аргумент, добавляем разделитель
              if [ "$searching_arg_current_number" -lt "$searching_args_number" ];
                then
                  snapshots_paremeters+=" | "
              fi

              # Учитываем обработанный аргумент в счётчике, чтобы не ставить
              # разделитель после последнего элемента в строке отчёта
              searching_arg_current_number=$(echo "$searching_arg_current_number + 1" | bc)

          # Ели параметр не age (не вычисляемый) осуществляем его поиск в данных AWS
          else

            # Подсчитываем сколько раз он встречается во всех снимках
            var_found_number=$(echo "$snapshots_description" | grep -i "$var" | wc | tr -s " " | cut -c 2- | cut -d " " -f 1)

            # Вычисляем сколько раз искомый параметр встречается в одном снимке
            var_repeat_in_one_snapshot=$(echo "$var_found_number / $snapshots_number" | bc)

            # Зная, сколько раз параметр встречается в одном снимке,
            # соответствующее количество раз осуществляем проводим поиск параметра
            # и вывод найденного значения в отчёт
            for (( repeat_count=1; repeat_count<="$var_repeat_in_one_snapshot"; repeat_count++ ))
            do
              snapshots_paremeters+=$(echo "$snapshots_description" | grep -i "$var" | head -n "$(echo "$repeat_count + ( ( $count - 1 ) * $var_repeat_in_one_snapshot )" | bc)" | tail -n 1 | tr -d \" | tr -d , | tr -d [ | tr -d ] | tr -d { | tr -d } | tr -s " " | cut -c 2-)

               # Если это не последний аргумент, добавляем разделитель
              if [ "$searching_arg_current_number" -lt "$searching_args_number" ];
                then
                  snapshots_paremeters+=" | "
              fi

              # Учитываем обработанный аргумент в счётчике, чтобы не ставить
              # разделитель после последнего элемента в строке отчёта
              searching_arg_current_number=$(echo "$searching_arg_current_number + 1" | bc)
            done
          fi
        done
        # Если это не последняя строка, добавляем символ конца строки "\n"
        if [ "$count" -lt "$snapshots_number" ];
          then
          snapshots_paremeters+="\n"
        fi
    fi
  done
  echo -e "$snapshots_paremeters"
}

# Формируем отчёт скрипта и подсчитываем, сколько в нём строк, если он не пустой
report=$(generate_report)
if [ -n "$report" ] # проверяем не пуст ли отчёт

  # Отчёт не пуст
  then
    echo "$report"
    repeat_number=$(echo "$report" | wc | tr -s " " | cut -c 2- | cut -d " " -f 1)

# Если отчёт пуст так то никаких команд далее не посылаем
else
  repeat_number="0"
fi

# Получаем регион AWS из файла настроек пользователя, запустившего скрипт
aws_region=$(cat ~/.aws/config | grep region | cut -d "=" -f 2 | cut -c 2-)

# Формируем перечень SnapshotId снимков для выполнения дальнейших команд
snapshots_id_list=$(generate_report "SnapshotId" | grep -oP "snap-[0-9a-fA-F]+")

# Формируем перечень Description снимков для выполнения дальнейших команд
descriptions_list=$(generate_report "Description" | cut -d ":" -f 2 | cut -c 2-)

# Если хотябы один снимок попал в отчёт (repeat_number > 0) выполняется цикл
for (( count=1; count<="$repeat_number"; count++ ))
do
  # Из подготовленного выше списка выделяем текущий SnapshotId
  snapshot_id_current=$(echo "$snapshots_id_list" | head -n "$count" | tail -n 1)

  # Из подготовленного выше списка выделяем текущий Description
  description_current=$(echo "$descriptions_list" | head -n "$count" | tail -n 1)

  # Если разрешено создание копий выбранных снимков - выполняем копирование
  if [ "$copy_selected" == "yes" ]
    then
      echo "$0 script: trying to make a copy of selected snapshots:"
      aws ec2 copy-snapshot --source-region "$aws_region" --source-snapshot-id "$snapshot_id_current" --description "Copy of: $description_current"
  fi

  # Если разрешено удаление выбранных снимков - выполняем удаление
  if [ "$delete_selected" == "yes" ]
    then
      echo "$0 script: trying to delete selected snapshots:"
      aws ec2 delete-snapshot --snapshot-id "$snapshot_id_current"
  fi
done

# Конец скрипта
exit 0

# ------------------------------------------------------------------------------
# Справочная информация по командам командам и операторам bash:
# https://www.opennet.ru/docs/RUS/bash_scripting_guide/x2565.html - операторы сравнения
# https://www.opennet.ru/docs/RUS/bash_scripting_guide/c2171.html - оператор test
# http://rus-linux.net/MyLDP/consol/awk.html - команда awk
# https://zalinux.ru/?p=1270 - grep опции и регулярные выражения
# http://www.opennet.ru/docs/RUS/perl_regex/ - регулярные выражения perl
# http://citforum.ru/internet/perl_tut/re.shtml - регулярные выражения perl
# Команда grep позволяет сортировать и фильтровать текст на основе сложных
# правил, определяемых опциями и шаблоном (регулярным выражением).
# Формат команды: команда | grep [опции] шаблон.
# Команда - это то место, где будет вестись поиск.
# Опции - это дополнительные параметры, с помощью которых указываются различные
# настройки поиска и вывода, например количество строк или режим инверсии.
# Шаблон - это любая строка или регулярное выражение, по которому будет вестись
# поиск.
# Регулярное выражение описывает набор строк. Регулярные выражения
# конструируются аналогично арифметическим выражениям с использованием различных
# операторов для комбинирования более маленьких выражений. grep понимает три
# различных типа синтаксисов регулярных выражений:
# «basic» (BRE), «extended» (ERE) и «perl» (PCRE).
# Основными строительными блоками являются регулярные выражения, которые
# соответствуют единичному символу. Большинство символов, включая все буквы и
# цифры, являются регулярными выражениями, которые соответствуют самим себе.
# Любой метасимвол со специальным значением может использоваться в буквальном
# их значении, если перед ним поставить обратный слеш.
# . точка соответствует любому единичному символу, кроме перевода строки.
# \. - соответствует точке
# Пустое регулярное выражение соответствует пустой строке.
# () круглые скобки обозначают начало "(" и конец ")" подмаски.
# {} фигурные скобки обозначают начало "{" и конец "}" квантификатора
# {n} повторение, предыдущий элемент встречается ровно n раз
#  \ общий экранирующий символ.
#  + квантификатор, означающий одно или более выражений
# \d - любая десятичная цифра
# Опции:
# -o показывать только часть строки, совпадающую с шаблоном
# -P интерпретировать шаблон как совместимое с Perl регулярное выражение (PCRE).
# [0-9a-fA-F]+ - выражение perl для поиска шестнадцатиричных чисел: поиск одного
# или нескольких следующих подряд символов в диапазоне 0–9, или a-f, или A-F

# Формат вызова: wc имя-файла<CR>
# wc возвращает строку параметрами
#   l       w       c       file
# где, l - число строк в файле, w - число слов в файле, c - число символов в
# файле, file - имя файла.

# Команда cut используется, если нужно вырезать часть текста — при этом он может
# находиться в файле либо быть напечатанным через стандартный ввод, в
# зависимости от опций:
# -c символ, который следует вырезать. Также можно указывать набор либо диапазон
#  символов.
# -d опция устанавливает свой разделитель вместо стандартного TAB.
# -f опция определяет перечень полей(номеров столбцов), которые следует вырезать

# date +"%FT%T" -u - возвращает текущую дату и время в формате гггг-мм-ддTчч:мм:сс
# date -d"2022-01-01T00:00:00" +%s -u возвращает количество секунд от начала
# эпохи ЭВМ на момент 1 января 2022 0 часов 0 минут 0 секунд

# Пример поиска подстроки в строке
# https://stackoverflow.com/questions/2829613/how-do-you-tell-if-a-string-contains-another-string-in-posix-sh
# contains(string, substring)
#
# Returns 0 if the specified string contains the specified substring,
# otherwise returns 1.
# contains() {
    # string="$1"
    # substring="$2"
    # if test "${string#*$substring}" != "$string"
    # then
        # return 0    # $substring is in $string
    # else
        # return 1    # $substring is not in $string
    # fi
# }
# contains "abcd" "e" || echo "abcd does not contain e"
# contains "abcd" "ab" && echo "abcd contains ab"
# contains "abcd" "bc" && echo "abcd contains bc"
# contains "abcd" "cd" && echo "abcd contains cd"
# contains "abcd" "abcd" && echo "abcd contains abcd"
# contains "" "" && echo "empty string contains empty string"
# contains "a" "" && echo "a contains empty string"
# contains "" "a" || echo "empty string does not contain a"
# contains "abcd efgh" "cd ef" && echo "abcd efgh contains cd ef"
# contains "abcd efgh" " " && echo "abcd efgh contains a space"

# Пример преобразования многострочного списка параметров в однострочный
# function list_to_string
# {
# echo "$1" > infile
# infile="infile"
# start='"'
# middle='", "'
# end='"'
# res="$start"                             # start the result with str "$start".
# while  IFS=$'\n' read -r line            # for each line in the file.
# do     res="${res}${line}${middle}"      # add the line and the middle str.
# done   <"$infile"                        # for file "$infile"
# res="${res%"$middle"}${end}"             # remove "$middle" on the last line.
# printf '%s\n' "${res}"                   # print result.
# rm infile
# }
