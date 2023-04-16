#!/bin/bash

# 定义监控间隔时间（单位：秒）
interval=5

# 定义初始内存使用情况
last_usage=0

# 循环监控 RAM 使用情况
while true
do
  # 获取当前时间
  timestamp=$(date)

  # 使用 free 命令获取可用内存和虚拟内存大小
  mem_info=($(free | awk 'NR==2{print $4} NR==3{print $7}'))

  # 将 KB 转换成 MB，并输出 RAM 和虚拟内存使用情况到命令行窗口
  echo "$timestamp ----- 可用运行内存 RAM: $((mem_info[0]/1024)) MB, 可用虚拟内存: $((mem_info[1]/1024)) MB"

  # 开始蓝色，如果当前内存使用情况比上一次低，则输出红色，否则绿色
  if [ $last_usage -eq 0 ]
  then
    tput setaf 12 # 蓝色
  else
    if [ ${mem_info[0]} -lt $last_usage ]
    then
      tput setaf 9 # 红色
    else
      tput setaf 10 # 绿色
    fi
  fi

  # 更新上一次使用情况，并等待指定的时间后继续下一轮监控
  last_usage=${mem_info[0]}
  sleep $interval

  rows=$((rows+1))
  if [ $rows -ge 500 ]
  then
    clear
    # ***** 日志备份 *****
    tput setaf 15 # 白色
    rows=0
    last_usage=0

    # 使用 free 命令获取可用虚拟内存大小
    vm_info=$(free | awk 'NR==3{print $7}')
    echo "VM $vm_info KB"
  fi
done