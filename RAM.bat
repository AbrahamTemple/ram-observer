@echo off
color

REM 定义监控间隔时间（单位：秒）
set interval=5

REM 定义初始内存使用情况
set last_usage=0

REM 设置计数器名称
set counter="\Memory\Available MBytes"

REM 使用 systeminfo 命令获取系统信息并查找可用虚拟内存大小
for /f "delims=" %%a in ('systeminfo ^| find "虚拟内存"') do (
  echo VM%%a
)

REM 循环监控 RAM 使用情况
:monitor
  REM 获取当前时间
  set timestamp=%date% %time%

  REM 使用 typeperf 命令获取 RAM 使用值
  for /f "skip=2 tokens=2 delims=," %%a in ('typeperf %counter% -sc 1') do (
    set mem_usage=%%a
  )

  REM 输出 RAM 使用情况和 RAM 占用率到命令行窗口
  echo %timestamp% ----- 可用运行内存 RAM: %mem_usage% MB
  
  REM 开始蓝色，如果当前内存使用情况比上一次低，则输出红色，否则绿色
    if %last_usage% EQU 0 (
    color 1F
  ) else (
    if %mem_usage% LSS %last_usage% (
      color 4F
    ) else (
      color 2F
    )
  )

  REM 更新上一次使用情况，并等待指定的时间后继续下一轮监控
  set last_usage=%mem_usage%
  timeout /t %interval% >nul

set /a rows+=1
if %rows% geq 500 (
  cls
  REM ***** 日志备份 *****
  color 0F
  set rows=0
  set last_usage=0

  for /f "delims=" %%a in ('systeminfo ^| find "虚拟内存"') do (
  echo %%a
)
)

goto monitor