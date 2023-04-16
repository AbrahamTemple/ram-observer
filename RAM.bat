@echo off
color

REM �����ؼ��ʱ�䣨��λ���룩
set interval=5

REM �����ʼ�ڴ�ʹ�����
set last_usage=0

REM ���ü���������
set counter="\Memory\Available MBytes"

REM ʹ�� systeminfo �����ȡϵͳ��Ϣ�����ҿ��������ڴ��С
for /f "delims=" %%a in ('systeminfo ^| find "�����ڴ�"') do (
  echo VM%%a
)

REM ѭ����� RAM ʹ�����
:monitor
  REM ��ȡ��ǰʱ��
  set timestamp=%date% %time%

  REM ʹ�� typeperf �����ȡ RAM ʹ��ֵ
  for /f "skip=2 tokens=2 delims=," %%a in ('typeperf %counter% -sc 1') do (
    set mem_usage=%%a
  )

  REM ��� RAM ʹ������� RAM ռ���ʵ������д���
  echo %timestamp% ----- ���������ڴ� RAM: %mem_usage% MB
  
  REM ��ʼ��ɫ�������ǰ�ڴ�ʹ���������һ�εͣ��������ɫ��������ɫ
    if %last_usage% EQU 0 (
    color 1F
  ) else (
    if %mem_usage% LSS %last_usage% (
      color 4F
    ) else (
      color 2F
    )
  )

  REM ������һ��ʹ����������ȴ�ָ����ʱ��������һ�ּ��
  set last_usage=%mem_usage%
  timeout /t %interval% >nul

set /a rows+=1
if %rows% geq 500 (
  cls
  REM ***** ��־���� *****
  color 0F
  set rows=0
  set last_usage=0

  for /f "delims=" %%a in ('systeminfo ^| find "�����ڴ�"') do (
  echo %%a
)
)

goto monitor