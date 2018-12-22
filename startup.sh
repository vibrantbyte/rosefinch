#!/usr/bin/env bash

filename=`basename "$0"`
workspace=$(cd $(dirname $0) && pwd)
nginx -c $workspace/nginx-testing.conf