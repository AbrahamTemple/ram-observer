#!/bin/bash

# �����ؼ��ʱ�䣨��λ���룩
interval=5

# �����ʼ�ڴ�ʹ�����
last_usage=0

# ѭ����� RAM ʹ�����
while true
do
  # ��ȡ��ǰʱ��
  timestamp=$(date)

  # ʹ�� free �����ȡ�����ڴ�������ڴ��С
  mem_info=($(free | awk 'NR==2{print $4} NR==3{print $7}'))

  # �� KB ת���� MB������� RAM �������ڴ�ʹ������������д���
  echo "$timestamp ----- ���������ڴ� RAM: $((mem_info[0]/1024)) MB, ���������ڴ�: $((mem_info[1]/1024)) MB"

  # ��ʼ��ɫ�������ǰ�ڴ�ʹ���������һ�εͣ��������ɫ��������ɫ
  if [ $last_usage -eq 0 ]
  then
    tput setaf 12 # ��ɫ
  else
    if [ ${mem_info[0]} -lt $last_usage ]
    then
      tput setaf 9 # ��ɫ
    else
      tput setaf 10 # ��ɫ
    fi
  fi

  # ������һ��ʹ����������ȴ�ָ����ʱ��������һ�ּ��
  last_usage=${mem_info[0]}
  sleep $interval

  rows=$((rows+1))
  if [ $rows -ge 500 ]
  then
    clear
    # ***** ��־���� *****
    tput setaf 15 # ��ɫ
    rows=0
    last_usage=0

    # ʹ�� free �����ȡ���������ڴ��С
    vm_info=$(free | awk 'NR==3{print $7}')
    echo "VM $vm_info KB"
  fi
done