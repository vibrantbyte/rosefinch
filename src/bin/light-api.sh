#!/usr/bin/env bash

filename=`basename "$0"`
workspace=$(cd $(dirname $0) && pwd)/../..

# 根据参数判定执行命令

:<<EOF
commands:
debug       调试
testing     测试
production  生产
EOF
help="Usage: light-api COMMAND [OPTIONS]\n
\n
The available commands are:\n
    debug       调试模式\n
    testing     测试模式\n
    production  生产模式\n
\n
Options:\n
    --start     启动\n
    --reload    重载\n
    --stop      停止\n
\n
";

# 支持command
commands=("debug" "testing" "production");
options=("--start" "--reload" "--stop")
echo "输入命令：$# , 值：$1 $2";

# 函数
# arr $1 原始数据集合
# element $2 需要验证的元素
# return boolean 是否包含
function func_include(){
    arr=$1
    element=$2

    # 默认不包含
    include=0;
    for i in ${arr[@]}
    do
        if [ "$i" == "$element" ]
        then
            include=1;
            break
        fi
    done;
    return $include;
};

# 判断环境配置
func_include "${commands[*]}" $1;
profile=$?;

# 判断options
func_include "${options[*]}" $2;
option=$?;

# 操作nginx脚本
# nginx_conf_file $1 nginx配置文件
# cmd $2 执行命令
function func_nginx(){
    nginx_conf_file=$1;
    cmd=$2;
    case $cmd in
    "--start")
        echo "nginx -c $workspace/$nginx_conf_file -p $workspace";
        nginx -c $workspace/$nginx_conf_file -p $workspace;
    ;;
    "--reload")
        echo "nginx -s reload -c $workspace/$nginx_conf_file -p $workspace";
        nginx -s reload -c $workspace/$nginx_conf_file -p $workspace;
    ;;
    "--stop")
        echo "nginx -s stop -c $workspace/$nginx_conf_file -p $workspace";
        nginx -s stop -c $workspace/$nginx_conf_file -p $workspace;
    ;;
    *)  echo "func_nginx ignorant"
    ;;
    esac
    echo "done"
};

# 启动命令
if [ "1" == "${profile}" ]&&[ "1" == "${option}" ]
then
 case $1 in
    "debug")
        echo "开始执行debug环境命令：func_nginx 'nginx-debug.conf' $2;"
        func_nginx "nginx-debug.conf" $2;
    ;;
    "testing")
        echo "开始执行testing环境命令：func_nginx 'nginx-testing.conf' $2;"
        func_nginx "nginx-testing.conf" $2;
    ;;
    "production")
        echo "开始执行testing环境命令：func_nginx 'nginx-production.conf' $2;"
        func_nginx "nginx-production.conf" $2;
    ;;
    *)  echo "ignorant"
    ;;
    esac
else
    # 打印帮助文档
    echo -e ${help}
fi