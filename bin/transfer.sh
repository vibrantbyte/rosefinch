#!/usr/bin/env bash

#获取当前目录
filename=`basename "$0"`
workspace=$(cd $(dirname $0) && pwd)/../
echo $workspace

prefix="${filename%.*}"
echo $prefix

environment=testing
lib_dir=$workspace/lib
conf_dir=$workspace/conf
app_name=$prefix
log_dir=$workspace/var/log
