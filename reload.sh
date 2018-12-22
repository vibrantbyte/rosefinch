#!/usr/bin/env bash
filename=`basename "$0"`
workspace=$(cd $(dirname $0) && pwd)
nginx -s reload -c $workspace/nginx-testing.conf