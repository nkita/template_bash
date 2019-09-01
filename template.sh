#!/bin/bash
<< comment
Name
   Template -- display general bash command
Synopis 
   template.sh [arg1] [arg2] [arg3]
Description
  テンプレート必要そうな基本コマンドをスクリプト作成に関するルールを記載
  定数：すべて大文字 例）DATA
  関数：スネークケースで記載。例）sample_function
  ローカル変数：先頭にアンダースコア。複数単語の場合２番目以降の単語は大文字。例）_sampleData
Revision
  2019.05.20 new
comment

# スクリプト設定
## ログファイルへの出力 y or n
LOG_OUTPUT_OPTION="n"

# グローバ変数定義エリア
LOGFILE="/tmp/template.log"
WORK_PATH=""
TMP_PATH="/tmp"

# スクリプト格納ディレクトリ
SCRIPT_HOME="$(cd $(dirname $0) && pwd)"

# 関数表示エリア
## 多重機能チェック
### argument：[Name],  return value: 0->True, -1->False
# chk_run(){
#    _name="/tmp/.$1"
#   if [ `check_path ${_name}`  -eq "0" ];then
#       exit 1
#   elif [ `check_path ${_name}` -eq "1" ];then
#       exit 0
#  fi
# }

## ログ出力
### argument：[File path][Message][I|W|E|R],  return value: Log file.
### [I|W|E|R]  R = "refresh". *Record a new log.
output_log(){
_message=$1; _option=$2; _write_detail_log=$3; _option_message="Info"; [ "${_option}" = "W" ] && _option_message="Warn"; [ "${_option}" = "E" ] && _option_message="Error"; [ ! "${_write_detail_log}" = "y" ] && _write_detail_log="n"
_output_message="[`date "+%Y/%m/%d-%H:%M:%S"]`[${_option_message}] ${_message} "
[ "${_option}" = "R" ] && : > ${LOGFILE}; [ "${LOG_OUTPUT_OPTION}" = "y" ] && echo -e ${_output_message} >> ${LOGFILE} 2>&1 || echo -e ${_output_message}
}

## ファイル・ディレクトリ存在チェック
### argument：[Path],  return value: 0->True, -1->False
check_path(){
  _path=$1
  if [ -e ${_path} ];then echo 0;else echo 1;fi
}

# =======
# MAIN処理 
# =======
## 引数
ARG1=$1
ARG2=$2

# コマンド存在チェック
_command_list=(
    "find"
#    "wget"
#    "ss"
)
for _command in "${_command_list[@]}" ; do
  which ${_command}
  if [ "$?" != "0" ]; then
        output_log ${LOGFILE} "${_command}: no find " "E"  
        exit 1;
  fi
done

#以下より先は削除して流用可能
output_log ${LOGFILE} "新しくログを記録します。" "R"
output_log ${LOGFILE} "Arg1=[${ARG1}], Arg2=[${ARG2}]"

## IF条件分岐
### =	-eq
### ≠	-ne
### <	-lt
### >	-gt
### ≦	-le
### ≧	-ge

#文字比較
if [ "${_option}" = "W" ];then
  _option_message="Warn"
elif [ "${_option}" = "E" ];then
  _option_message="Error"
else
  _option_message="Info"
fi

## ファイルチェック
PARAM1=`check_path "/tmp2"`
PARAM2=`check_path "/tmp"`
output_log ${LOGFILE}  "File check PARAM1=${PARAM1}" 

## while文
## while option -d delimiter
### ファイルパス一覧
#DATAFILE=***.txt
#while read line ; do
#    echo ${line}
#done < ${DATAFILE}

## for文
### 連番によるループ
count=0
for _i in {1..3};do
  # bash インクリメント
  _count=$((++count))
  output_log ${LOGFILE} "Num loop i=${_i}" 
  output_log ${LOGFILE} "_count loop _count=${_count}" 
done

### 引数ループ
for arg; do
  output_log ${LOGFILE} "Args Loop ${arg}"
done

### command ループ
 _loop_command=(`ls -1 /tmp | head -3`)
for _list in "${_loop_command[@]}"; do
  output_log ${LOGFILE} "Command loop result [${_list}]"
done

### 配列ループ
_loop_array=(
    "conf1"
    "conf2"
)
for _array in "${_loop_array[@]}" ; do
  output_log ${LOGFILE} "Array loop [${_array}]"
done

### 2次元配列
declare -A _loop_2d_array;
_loop_2d_array=(
  ["c1"]="1番目の設定"
  ["c2"]="2番目の設定"
)
# 連想配列のループ
for _2d_array in ${!_loop_2d_array[@]};
do
  output_log ${LOGFILE} "2D Array loop [${_2d_array}]=[${_loop_2d_array[${_2d_array}]}]"
done
# direct => ${_loop_2d_array["c1"]}
