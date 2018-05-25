## k8s 常用脚本

在 `~/.bash_profile` 中增加以下别名：

```yaml
# get
alias pod="sh ~/scripts/get_pods.sh"
alias dep="sh ~/scripts/get_deployments.sh"
alias node="sh ~/scripts/get_nodes.sh"
alias svc="sh ~/scripts/get_services.sh"
alias ing="sh ~/scripts/get_ings.sh"
alias ds="sh ~/scripts/get_daemonset.sh"

alias logs="sh ~/scripts/logs_pod.sh"
alias desc="sh ~/scripts/describe_pod.sh"

# delete
alias deldep="sh ~/scripts/delete_deployment.sh"
alias delpod="sh ~/scripts/delete_pod.sh"
alias delsvc="sh ~/scripts/delete_service.sh"
```