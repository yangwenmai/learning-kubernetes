#!/bin/sh

docker pull anjia0532/kube-apiserver-amd64:v1.10.2
docker pull anjia0532/kube-scheduler-amd64:v1.10.2
docker pull anjia0532/kube-controller-manager-amd64:v1.10.2
docker pull anjia0532/kube-proxy-amd64:v1.10.2
docker pull anjia0532/k8s-dns-kube-dns-amd64:1.14.10
docker pull anjia0532/k8s-dns-dnsmasq-nanny-amd64:1.14.10
docker pull anjia0532/k8s-dns-sidecar-amd64:1.14.10
docker pull anjia0532/etcd-amd64:3.2.18
docker pull cnych/flannel:v0.10.0-amd64
docker pull anjia0532/pause-amd64:3.1

docker tag anjia0532/kube-apiserver-amd64:v1.10.2 k8s.gcr.io/kube-apiserver-amd64:v1.10.2
docker tag anjia0532/kube-scheduler-amd64:v1.10.2 k8s.gcr.io/kube-scheduler-amd64:v1.10.2
docker tag anjia0532/kube-controller-manager-amd64:v1.10.2 k8s.gcr.io/kube-controller-manager-amd64:v1.10.2
docker tag anjia0532/kube-proxy-amd64:v1.10.2 k8s.gcr.io/kube-proxy-amd64:v1.10.2
docker tag anjia0532/k8s-dns-kube-dns-amd64:1.14.10 k8s.gcr.io/k8s-dns-kube-dns-amd64:1.14.10
docker tag anjia0532/k8s-dns-dnsmasq-nanny-amd64:1.14.10 k8s.gcr.io/k8s-dns-dnsmasq-nanny-amd64:1.14.10
docker tag anjia0532/k8s-dns-sidecar-amd64:1.14.10 k8s.gcr.io/k8s-dns-sidecar-amd64:1.14.10
docker tag anjia0532/etcd-amd64:3.2.18 k8s.gcr.io/etcd-amd64:3.2.18
docker tag cnych/flannel:v0.10.0-amd64 quay.io/coreos/flannel:v0.10.0-amd64
docker tag anjia0532/pause-amd64:3.1 k8s.gcr.io/pause-amd64:3.1
