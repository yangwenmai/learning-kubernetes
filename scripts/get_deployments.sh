#!/bin/sh
if [ $# == 0 ]; then
  echo "kubectl get deployment --all-namespaces"
  kubectl get deployment --all-namespaces $*
else
  echo "kubectl get deployment -n $*"
  kubectl get deployment -n $*
fi
