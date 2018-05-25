#!/bin/sh
if [ $# == 0 ]; then
  echo "kubectl get ing --all-namespaces"
  kubectl get ing --all-namespaces $*
else
  echo "kubectl get ing -n $*"
  kubectl get ing -n $*
fi
