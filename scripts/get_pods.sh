#!/bin/sh
if [ $# == 0 ]; then
  echo "kubectl get pods --all-namespaces"
  kubectl get pods --all-namespaces $*
else
  echo "kubectl get pods -n $*"
  kubectl get pods -n $*
fi
