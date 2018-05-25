#!/bin/sh
# 如果$2 为空则默认default
if [ $# == 1 ]; then
  echo "kubectl describe pod $1 -n default"
  kubectl describe pod $1
elif [ $# == 2 ]; then
  echo "kubectl describe pod $1 -n $2"
  kubectl describe pod $1 -n $2
else
  echo "kubectl describe pod $1 -n $2 ${@:3:${$#}-3}"
  kubectl describe pod $1 -n $2 ${@:3:${$#}-3}
fi
