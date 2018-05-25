#!/bin/sh
if [ $# == 0 ]; then
  echo "kubectl get services --all-namespaces"
  kubectl get services --all-namespaces $*
else
  echo "kubectl get services -n $*"
  kubectl get services -n $*
fi
