#!/bin/sh
if [ $# == 0 ]; then
  echo "kubectl get ds --all-namespaces"
  kubectl get ds --all-namespaces $*
else
  echo "kubectl get ds -n $*"
  kubectl get ds -n $*
fi
