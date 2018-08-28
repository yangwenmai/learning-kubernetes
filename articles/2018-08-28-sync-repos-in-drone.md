# Drone 同步 repos 的策略研讨和源码分析

本文是来自于社群中一位小伙伴对于 Drone 使用过程中遇到的问题的答疑，延伸出来的一篇策略探讨和源码分析，希望能对你有所帮助。

----

## Drone 能不能在新建的 repos 的时候直接同步到 Drone Dashboard 中呢？

>答案是：不能。

>你只能进入用户控制界面，然后单击 "Synchronize" 按钮，此时新的 repos 就会在 repos 列表中显示了。

![](https://discourse-cdn-sjc2.com/standard14/uploads/drone/optimized/1X/e5e35c2f55599eb9b57e00a36576a430bf27485d_1_641x500.png)

## 为什么没有利用组织 Webhook 来做更酷的自动同步呢？

因为 Drone 需要评估所有源代码管理提供商（gitlab，gitea，gogs，bitbucket，stash，coding）是否有全面提供此功能。

目前 drone 只提供同步的 API。

例如，你可以设置一个简单的 hook 配置：

```
echo <<EOF > /some/local/config
{
    "scripts": [
        {
            "command": "curl",
            "args": [
                "-x", 
                "POST", 
                "-H", 
                "Authorization: Bearer {token}", 
                "https://drone.company.com/api/user/repos?all=true&flush=true"
            ]
        }
    ]
}
EOF
```

然后运行 docker 镜像：

```sh
docker run -d -v /some/local/config:/config bketelsen/captainhook
```

## 如何通过 API 来触发调用呢？

在你的控制面板上调用 API，可以使用你的个人帐户 token 直接调用用户界面可用的任何功能。

推荐的做法是：

1. 使用 chrome developer tools 网络检查器查看如何调用 API 调用，并确保正确调用它（正确的路径，方法等）
2. 检查数据库以查看是否添加了 repo。 `select * from repos where repo_full_name ='foo / bar'`
3. 同步你的个人账户，仅与机器人同步是不够的，因为 drone 仍需要同步你的账户并同步你的各个 repo 的权限。

## 是否存在某种后台同步进程？

没有后台同步进程的。

当用户请求 repos 列表（通过 UI 或 API）时，如果之前的同步超过 72 小时，它将触发同步。

```golang
func GetRepos(c *gin.Context) {
	// ...
	// flush 强制刷新/同步。
	// 用户同步的时间超过 72 小时，也将进行同步。
	if flush || time.Unix(user.Synced, 0).Add(time.Hour*72).Before(time.Now()) {
		logrus.Debugf("sync begin: %s", user.Login)
		user.Synced = time.Now().Unix()
		store.FromContext(c).UpdateUser(user)

		sync := syncer{
			remote:  remote.FromContext(c),
			store:   store.FromContext(c),
			perms:   store.FromContext(c),
			limiter: Config.Services.Limiter,
		}
		if err := sync.Sync(user); err != nil {
			logrus.Debugf("sync error: %s: %s", user.Login, err)
		} else {
			logrus.Debugf("sync complete: %s", user.Login)
		}
	}
	// ...
}
```

[https://github.com/drone/drone/blob/master/server/sync.go](https://github.com/drone/drone/blob/master/server/sync.go)

```golang
// Syncer 同步用户的 repos 和许可。
type Syncer interface {
	Sync(user *model.User) error
}

type syncer struct {
	remote  remote.Remote
	store   store.Store
	perms   model.PermStore
	limiter model.Limiter
}

func (s *syncer) Sync(user *model.User) error {
	unix := time.Now().Unix() - (3601) // 强制立即过期。注意 1 小时过期是硬编码的。
	repos, err := s.remote.Repos(user)
	if err != nil {
		return err
	}

	// 配置了分页的获取 repos
	if s.limiter != nil {
		repos = s.limiter.LimitRepos(user, repos)
	}

	var perms []*model.Perm
	for _, repo := range repos {
		perm := model.Perm{
			UserID: user.ID,
			Repo:   repo.FullName,
			Pull:   true,
			Synced: unix,
		}
		if repo.Perm != nil {
			perm.Push = repo.Perm.Push
			perm.Admin = repo.Perm.Admin
		}
		perms = append(perms, &perm)
	}

	// 批量更新 repos 信息
	// INSERT IGNORE INTO repos
	err = s.store.RepoBatch(repos)
	if err != nil {
		return err
	}

	// 批量更新许可
	// REPLACE INTO perms 
	err = s.store.PermBatch(perms)
	if err != nil {
		return err
	}

	// 这是一个预防措施。
	// 我想确保如果对版本控制系统的 api 调用失败并且（由于某种原因）返回空列表，我们不会消除用户 repos 权限。

	// 此代码的副作用是具有1个已删除访问权限的 repo 的用户仍将显示在源中，但他们将无法访问实际的 repo 数据。
	if len(repos) == 0 {
		return nil
	}

	// 将过期的删除
	// DELETE FROM perms WHERE perm_user_id = ? AND perm_synced < ?
	return s.perms.PermFlush(user, unix)
}
```

----

## 参考资料

1. [optimize repository synchronization process #2230](https://github.com/drone/drone/issues/2230)
2. [Remove local cache of all user repos. No more syncing #776](https://github.com/drone/drone/issues/776)
3. [Improve Dashboard, Repo List, Feed #1234](https://github.com/drone/drone/issues/1234)
4. [drone 未能通过 API 同步新的 github repos](https://discourse.drone.io/t/drone-fails-to-sync-new-github-repos-via-the-api/728)
